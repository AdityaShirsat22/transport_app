import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';
import '../constants/app_constants.dart';


class AppUser {
  final String id;
  final String email;
  final String name;
  final String role; // 'Super Admin', 'Admin', etc.

  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.role = 'Super Admin',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        role: json['role'] as String? ?? 'Super Admin',
      );
}

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const _sessionKey = 'freightops_secure_session';
  static const _prefsSessionKey = 'freightops_persisted_user_session';
  static const _lastRouteKey = 'freightops_last_active_route';

  String? _cachedLastRoute;
  String? getCachedLastRoute() => _cachedLastRoute;

  Future<void> saveLastRoute(String route) async {
    if (route.isEmpty || route == '/login' || route == '/forgot-password') return;
    _cachedLastRoute = route;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastRouteKey, route);
    } catch (_) {}
  }

  Future<void> clearLastRoute() async {
    _cachedLastRoute = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastRouteKey);
    } catch (_) {}
  }

  SupabaseClient? get _client {
    if (EnvConfig.isSupabaseConfigured) {
      try {
        return Supabase.instance.client;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Initialize session from secure storage, SharedPreferences, or Supabase
  Future<AppUser?> restoreSession() async {
    // 0. Preload last active route
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedLastRoute = prefs.getString(_lastRouteKey);
    } catch (_) {}

    // 1. Try Supabase session if configured
    final client = _client;
    if (client != null && client.auth.currentSession != null) {
      final user = client.auth.currentUser;
      if (user != null) {
        final appUser = AppUser(
          id: user.id,
          email: user.email ?? EnvConfig.adminEmail,
          name: (user.userMetadata?['name'] as String?) ?? AppConstants.defaultUserName,
          role: (user.userMetadata?['role'] as String?) ?? AppConstants.defaultUserRole,
        );
        await _saveLocalSession(appUser);
        return appUser;
      }
    }

    // 2. Check local encrypted storage
    try {
      final raw = await _secureStorage.read(key: _sessionKey);
      if (raw != null && raw.isNotEmpty) {
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          final appUser = AppUser.fromJson(map);
          // Sync to SharedPreferences for resilience
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_prefsSessionKey, raw);
          return appUser;
        } catch (_) {
          await _secureStorage.delete(key: _sessionKey);
        }
      }
    } catch (_) {
      // Fallback if secure storage is unlinked or restricted on platform
    }

    // 3. Resilient fallback: SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsSessionKey);
      if (raw != null && raw.isNotEmpty) {
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          final appUser = AppUser.fromJson(map);
          return appUser;
        } catch (_) {
          await prefs.remove(_prefsSessionKey);
        }
      }
    } catch (_) {}

    return null;
  }

  /// Sign In with email and password
  Future<AppUser> signIn(String email, String password) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.auth.signInWithPassword(
          email: email.trim(),
          password: password,
        );
        final user = response.user;
        if (user == null) {
          throw Exception('Login failed: user not found');
        }

        final appUser = AppUser(
          id: user.id,
          email: user.email ?? email,
          name: (user.userMetadata?['name'] as String?) ?? AppConstants.defaultUserName,
          role: (user.userMetadata?['role'] as String?) ?? AppConstants.defaultUserRole,
        );

        await _saveLocalSession(appUser);
        return appUser;
      } catch (e) {
        // Re-throw Supabase auth exceptions
        throw Exception(e.toString());
      }
    } else {
      // Local/Offline standalone mode validation
      if (email.trim().toLowerCase() == EnvConfig.adminEmail.toLowerCase() &&
          password.length >= 6) {
        final appUser = AppUser(
          id: 'user-admin-local-1',
          email: email.trim(),
          name: AppConstants.defaultUserName,
          role: AppConstants.defaultUserRole,
        );
        await _saveLocalSession(appUser);
        return appUser;
      } else if (password.length >= 6) {
        // Allow developer login with any valid formatted email + password
        final appUser = AppUser(
          id: 'user-${DateTime.now().millisecondsSinceEpoch}',
          email: email.trim(),
          name: email.split('@').first,
          role: 'Super Admin',
        );
        await _saveLocalSession(appUser);
        return appUser;
      } else {
        throw Exception('Password must be at least 6 characters.');
      }
    }
  }

  /// Sign In with 4-Digit PIN (validated against Supabase staff_pins table)
  Future<AppUser> loginWithPin({
    required String pin,
    required String role,
    String? name,
    String? email,
  }) async {
    final client = _client;

    if (client != null) {
      // Online: validate PIN against Supabase staff_pins table
      try {
        final result = await client
            .from('staff_pins')
            .select('id, name, email, role, is_active')
            .eq('pin_code', pin.trim())
            .eq('role', role)
            .eq('is_active', true)
            .maybeSingle();

        if (result == null) {
          throw Exception('Invalid PIN. Please contact your administrator.');
        }

        final appUser = AppUser(
          id: result['id'] as String,
          email: (result['email'] as String?) ?? 'staff@freightops.com',
          name: (result['name'] as String?) ?? role,
          role: result['role'] as String? ?? role,
        );

        // Sign into Supabase anonymously so the coordinator gets an
        // `authenticated` session. Without this, all RLS-protected table
        // reads (transports, transport_allocations, etc.) return empty
        // results and the coordinator sees no data on their device.
        try {
          if (client.auth.currentSession == null) {
            await client.auth.signInAnonymously();
          }
        } catch (_) {
          // Non-fatal: we still complete the login with a local session.
          // The coordinator will see cached data if any exists locally.
        }

        await _saveLocalSession(appUser);
        return appUser;
      } catch (e) {
        final msg = e.toString();
        // If the error is our own formatted exception, rethrow
        if (msg.contains('Invalid PIN')) {
          throw Exception('Invalid PIN. Please contact your administrator.');
        }
        // Network / Supabase error
        throw Exception('Could not verify PIN. Check your connection and try again.');
      }
    } else {
      // Offline mode: PIN login not available without Supabase connection
      throw Exception(
        'PIN login requires an active internet connection. '
        'Please connect and try again, or contact your administrator.',
      );
    }
  }

  /// Reset password request
  Future<void> sendPasswordReset(String email) async {
    final client = _client;
    if (client != null) {
      await client.auth.resetPasswordForEmail(email.trim());
    }
  }

  /// Sign Out and clear all local session storage
  Future<void> signOut() async {
    try {
      final client = _client;
      if (client != null) {
        await client.auth.signOut();
      }
    } catch (_) {}
    try {
      await _secureStorage.delete(key: _sessionKey);
    } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsSessionKey);
      await prefs.remove(_lastRouteKey);
    } catch (_) {}
    _cachedLastRoute = null;
  }

  Future<void> _saveLocalSession(AppUser user) async {
    final encoded = jsonEncode(user.toJson());
    // 1. Save to secure storage
    try {
      await _secureStorage.write(
        key: _sessionKey,
        value: encoded,
      );
    } catch (_) {}

    // 2. Save to SharedPreferences for resilient cross-platform persistence
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsSessionKey, encoded);
    } catch (_) {}
  }
}
