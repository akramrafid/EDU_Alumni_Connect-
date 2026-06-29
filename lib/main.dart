import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_config.dart';
import 'core/di/firebase_initializer.dart';
import 'app.dart';

// Provider to expose environment configuration to the rest of the application
final appConfigProvider = Provider<AppConfig>((ref) => throw UnimplementedError());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables via --dart-define
  final config = AppConfig.fromEnvironment();

  // Pre-initialize Firebase and App Check
  await FirebaseInitializer.initialize();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
      ],
      child: const EduAlumniConnectApp(),
    ),
  );
}
