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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA9T6IA8tlR0vhJVFjjF4qPzi8WdiINfIA',
    appId: '1:41878663380:web:fa644d6f944e858c934b41',
    messagingSenderId: '41878663380',
    projectId: 'hostit-995c1',
    authDomain: 'hostit-995c1.firebaseapp.com',
    storageBucket: 'hostit-995c1.appspot.com',
    measurementId: 'G-QDHZT02CMP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjwyiwF4CveFlg6vtsrCSy48exKF7jnTU',
    appId: '1:41878663380:android:5824e51f3754abaa934b41',
    messagingSenderId: '41878663380',
    projectId: 'hostit-995c1',
    storageBucket: 'hostit-995c1.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA9T6IA8tlR0vhJVFjjF4qPzi8WdiINfIA',
    appId: '1:41878663380:web:35a434c8c8e46f29934b41',
    messagingSenderId: '41878663380',
    projectId: 'hostit-995c1',
    authDomain: 'hostit-995c1.firebaseapp.com',
    storageBucket: 'hostit-995c1.appspot.com',
    measurementId: 'G-BE5KEKGCK2',
  );
}
