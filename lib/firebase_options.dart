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
    apiKey: 'AIzaSyCRXbDewKuUgiERKj15O2P6HPnDI3E3XG0',
    appId: '1:697020894700:web:fdabca6651a8c909b804c9',
    messagingSenderId: '697020894700',
    projectId: 'instagram-clone-2cc86',
    authDomain: 'instagram-clone-2cc86.firebaseapp.com',
    storageBucket: 'instagram-clone-2cc86.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAfUz8knpj04nNQ2PrCwub1gaJ14ohqmVk',
    appId: '1:697020894700:android:cf1207e0546d0450b804c9',
    messagingSenderId: '697020894700',
    projectId: 'instagram-clone-2cc86',
    storageBucket: 'instagram-clone-2cc86.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAM8tesUdLcbBtzaB44Eo5pLdzEjN5evgo',
    appId: '1:697020894700:ios:df202218f71767e5b804c9',
    messagingSenderId: '697020894700',
    projectId: 'instagram-clone-2cc86',
    storageBucket: 'instagram-clone-2cc86.appspot.com',
    iosBundleId: 'com.example.instagramClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAM8tesUdLcbBtzaB44Eo5pLdzEjN5evgo',
    appId: '1:697020894700:ios:df202218f71767e5b804c9',
    messagingSenderId: '697020894700',
    projectId: 'instagram-clone-2cc86',
    storageBucket: 'instagram-clone-2cc86.appspot.com',
    iosBundleId: 'com.example.instagramClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCRXbDewKuUgiERKj15O2P6HPnDI3E3XG0',
    appId: '1:697020894700:web:a2a146133729ad95b804c9',
    messagingSenderId: '697020894700',
    projectId: 'instagram-clone-2cc86',
    authDomain: 'instagram-clone-2cc86.firebaseapp.com',
    storageBucket: 'instagram-clone-2cc86.appspot.com',
  );
}
