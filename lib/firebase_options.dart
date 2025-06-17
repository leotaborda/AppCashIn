// File generated manually from your google-services.json
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// Usage example:
/// ```dart
/// import 'firebase_options.dart';
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web platform not configured. Run flutterfire configure to add web support.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS platform not configured. Run flutterfire configure to add iOS support.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'macOS platform not configured. Run flutterfire configure to add macOS support.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows platform not configured. Run flutterfire configure to add Windows support.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Linux platform not configured. Run flutterfire configure to add Linux support.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8byVkl3USlX2D8LpDdd2OIcpBvwII2HE',
    appId: '1:1085955571908:android:f00e5c82f3918d08f84991',
    messagingSenderId: '1085955571908',
    projectId: 'cashin-e6dee',
    storageBucket: 'cashin-e6dee.firebasestorage.app',
  );
}
