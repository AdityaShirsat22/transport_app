import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'core/config/env_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (EnvConfig.isSupabaseConfigured) {
    try {
      // ignore: deprecated_member_use
      await Supabase.initialize(
        url: EnvConfig.supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: EnvConfig.supabaseAnonKey,
      );
    } catch (_) {
      // Gracefully continue in local-first offline mode
    }
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      storage: DevicePreviewStorage.none(),
      builder: (context) => const ProviderScope(
        child: TransportApp(),
      ),
    ),
  );
}
