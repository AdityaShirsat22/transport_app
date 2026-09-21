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
  static const _attendanceSessionKey = 'freightops_attendance_session';

  String? _cachedLastRoute;
  String? getCachedLastRoute() => _cachedLastRoute;

  bool _isAttendanceSessionActive = false;
  bool get isAttendanceSessionActive => _isAttendanceSessionActive;

  Future<void> saveAttendanceSession({
    required String role,
    String? terminal,
  }) async {
    _isAttendanceSessionActive = true;
    final sessionData = jsonEncode({
      'isUnlocked': true,
      'unlockedAt': DateTime.now().toIso8601String(),
      'role': role,
      'terminal': terminal ?? 'Main Operations Terminal',
    });

    try {
      await _secureStorage.write(key: _attendanceSessionKey, value: sessionData);
    } catch (_) {}

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_attendanceSessionKey, sessionData);
    } catch (_) {}
  }

  Future<bool> hasActiveAttendanceSession() async {
    if (_isAttendanceSessionActive) return true;

    try {
      final raw = await _secureStorage.read(key: _attendanceSessionKey);
      if (raw != null && raw.isNotEmpty) {
        _isAttendanceSessionActive = true;
        return true;
      }
    } catch (_) {}

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_attendanceSessionKey);
      if (raw != null && raw.isNotEmpty) {
        _isAttendanceSessionActive = true;
        return true;
      }
    } catch (_) {}

    return false;
  }

  Future<Map<String, dynamic>?> getAttendanceSessionDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_attendanceSessionKey);
      if (raw != null && raw.isNotEmpty) {
        return jsonDecode(raw) as Map<String, dynamic>;
      }
    } catch (_) {}

    try {
      final raw = await _secureStorage.read(key: _attendanceSessionKey);
      if (raw != null && raw.isNotEmpty) {
        return jsonDecode(raw) as Map<String, dynamic>;
      }
    } catch (_) {}

    return null;
  }

  Future<void> clearAttendanceSession() async {
    _isAttendanceSessionActive = false;
    try {
      await _secureStorage.delete(key: _attendanceSessionKey);
    } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_attendanceSessionKey);
    } catch (_) {}
  }

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
    // 0. Preload last active route & attendance session status
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedLastRoute = prefs.getString(_lastRouteKey);
      final att = prefs.getString(_attendanceSessionKey);
      if (att != null && att.isNotEmpty) {
        _isAttendanceSessionActive = true;
      }
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

  /// Sign In with 4-Digit PIN (for demo, PIN is 1170)
  Future<AppUser> loginWithPin({
    required String pin,
    required String role,
    String? name,
    String? email,
  }) async {
    const demoPin = '1170';
    if (pin.trim() != demoPin) {
      throw Exception('Invalid 4-digit PIN. Enter 1170 for demo access.');
    }

    final defaultName = switch (role) {
      'Super Admin' => AppConstants.defaultUserName,
      'Coordinator' => 'Operations Coordinator',
      'Driver' => 'Fleet Driver',
      _ => 'Staff Member',
    };

    final defaultEmail = switch (role) {
      'Super Admin' => EnvConfig.adminEmail,
      'Coordinator' => 'coordinator@freightops.com',
      'Driver' => 'driver@freightops.com',
      _ => 'user@freightops.com',
    };

    final appUser = AppUser(
      id: 'pin-user-${role.toLowerCase().replaceAll(' ', '-')}',
      email: email ?? defaultEmail,
      name: name ?? defaultName,
      role: role,
    );

    await _saveLocalSession(appUser);
    return appUser;
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
      await _secureStorage.delete(key: _attendanceSessionKey);
    } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsSessionKey);
      await prefs.remove(_lastRouteKey);
      await prefs.remove(_attendanceSessionKey);
    } catch (_) {}
    _cachedLastRoute = null;
    _isAttendanceSessionActive = false;
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
