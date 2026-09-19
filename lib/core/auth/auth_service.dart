import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  /// Initialize session from secure storage or Supabase
  Future<AppUser?> restoreSession() async {
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
      if (raw != null) {
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          return AppUser.fromJson(map);
        } catch (_) {
          await _secureStorage.delete(key: _sessionKey);
        }
      }
    } catch (_) {
      // Safe fallback if platform secure storage plugin is unlinked
    }

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

  /// Reset password request
  Future<void> sendPasswordReset(String email) async {
    final client = _client;
    if (client != null) {
      await client.auth.resetPasswordForEmail(email.trim());
    }
  }

  /// Sign Out and clear secure storage
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
  }

  Future<void> _saveLocalSession(AppUser user) async {
    try {
      await _secureStorage.write(
        key: _sessionKey,
        value: jsonEncode(user.toJson()),
      );
    } catch (_) {}
  }
}
