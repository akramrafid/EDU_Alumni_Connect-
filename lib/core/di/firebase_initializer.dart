import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseInitializer {
  FirebaseInitializer._();

  static Future<void> initialize() async {
    try {
      try {
        await Firebase.initializeApp();
      } catch (e) {
        debugPrint('Failed to initialize Firebase with native resources, falling back to dummy options: $e');
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "dummy-api-key-for-local-dev-only",
            appId: "1:1234567890:android:dummyapp",
            messagingSenderId: "1234567890",
            projectId: "edu-alumni-connect-dummy",
            storageBucket: "edu-alumni-connect-dummy.appspot.com",
          ),
        );
      }

      // Configure App Check according to the platform-specific rules
      // (only run if using actual Firebase configuration)
      if (Firebase.app().options.apiKey != "dummy-api-key-for-local-dev-only") {
        await FirebaseAppCheck.instance.activate(
          webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
          androidProvider: kDebugMode
              ? AndroidProvider.debug
              : AndroidProvider.playIntegrity,
          appleProvider: kDebugMode
              ? AppleProvider.debug
              : AppleProvider.appAttest,
        );
      }
    } catch (e) {
      // Safely catch initialization exceptions in environments where config files are not yet provisioned
      debugPrint('Firebase initialization warning/error: $e');
    }
  }
}
