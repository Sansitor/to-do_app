import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_API_ID',
    messagingSenderId: 'MESSAGE_SENDER_ID',
    projectId: 'PROJECT_ID',
    authDomain: 'AUTH_DOMAIN',
    storageBucket: 'STORAGE_BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_API_ID',
    messagingSenderId: 'MESSAGE_SENDER_ID',
    projectId: 'PROJECT_ID',
    storageBucket: 'STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_API_ID',
    messagingSenderId: 'MESSAGE_SENDER_ID',
    projectId: 'PROJECT_ID',
    storageBucket: 'STORAGE_BUCKET',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_API_ID',
    messagingSenderId: 'MESSAGE_SENDER_ID',
    projectId: 'PROJECT_ID',
    storageBucket: 'STORAGE_BUCKET',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_API_ID',
    messagingSenderId: 'MESSAGE_SENDER_ID',
    projectId: 'PROJECT_ID',
    authDomain: 'AUTH_DOMAIN',
    storageBucket: 'STORAGE_BUCKET',
  );
}
