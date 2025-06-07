import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummyApiKey',
    appId: '1:123456789012:web:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'dil-pratik',
    authDomain: 'dil-pratik.firebaseapp.com',
    storageBucket: 'dil-pratik.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDummyApiKey',
    appId: '1:123456789012:android:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'dil-pratik',
    storageBucket: 'dil-pratik.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummyApiKey',
    appId: '1:123456789012:ios:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'dil-pratik',
    storageBucket: 'dil-pratik.appspot.com',
    iosClientId: 'ios-client-id.apps.googleusercontent.com',
    iosBundleId: 'com.example.dilPratik',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDummyApiKey',
    appId: '1:123456789012:macos:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'dil-pratik',
    storageBucket: 'dil-pratik.appspot.com',
    iosClientId: 'macos-client-id.apps.googleusercontent.com',
    iosBundleId: 'com.example.dilPratik',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDummyApiKey',
    appId: '1:123456789012:windows:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'dil-pratik',
    storageBucket: 'dil-pratik.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDummyApiKey',
    appId: '1:123456789012:linux:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'dil-pratik',
    storageBucket: 'dil-pratik.appspot.com',
  );
}
