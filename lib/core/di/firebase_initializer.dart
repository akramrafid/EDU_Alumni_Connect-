import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseInitializer {
  FirebaseInitializer._();

  static Future<void> initialize() async {
    try {
      // Initialize Firebase (will load options automatically from platform config files:
      // google-services.json for Android / GoogleService-Info.plist for iOS)
      await Firebase.initializeApp();

      // Configure App Check according to the platform-specific rules
      await FirebaseAppCheck.instance.activate(
        webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
        androidProvider: kDebugMode
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,
        appleProvider: kDebugMode
            ? AppleProvider.debug
            : AppleProvider.appAttest,
      );
    } catch (e) {
      // Safely catch initialization exceptions in environments where config files are not yet provisioned
      debugPrint('Firebase initialization warning/error: $e');
    }
  }
}
