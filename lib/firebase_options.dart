// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDa-KKJMO8BH9A025HsYBxkHhkp1phrS8E',
    appId: '1:451496443108:android:1da145be66d2085f3ec0f1',
    messagingSenderId: '451496443108',
    projectId: 'firefighter-3278c',
    databaseURL: 'https://firefighter-3278c-default-rtdb.firebaseio.com',
    storageBucket: 'firefighter-3278c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0h2SoG3nsjYm2TlreV_5tu3L3-IChGo4',
    appId: '1:451496443108:ios:ef80adf7d4f69f1a3ec0f1',
    messagingSenderId: '451496443108',
    projectId: 'firefighter-3278c',
    databaseURL: 'https://firefighter-3278c-default-rtdb.firebaseio.com',
    storageBucket: 'firefighter-3278c.appspot.com',
    iosBundleId: 'com.example.fireFighter',
  );
}
