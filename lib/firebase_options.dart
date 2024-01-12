// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA9OwSpyeSIqlZfsrIU40a8Wz1x-7rj-Dw',
    appId: '1:559631361002:web:5ebbc97bb8561068e10893',
    messagingSenderId: '559631361002',
    projectId: 'smart-reclam',
    authDomain: 'smart-reclam.firebaseapp.com',
    storageBucket: 'smart-reclam.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKrdkoRyADzQGKGDwqCTIAXZTvaZOPprI',
    appId: '1:559631361002:android:d06f870cc68cbb94e10893',
    messagingSenderId: '559631361002',
    projectId: 'smart-reclam',
    storageBucket: 'smart-reclam.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfQvFSR6tjRaS8llrnwZr2zt_KfxLqAp4',
    appId: '1:559631361002:ios:f2b151a54e106b32e10893',
    messagingSenderId: '559631361002',
    projectId: 'smart-reclam',
    storageBucket: 'smart-reclam.appspot.com',
    iosBundleId: 'com.example.flutterApplication2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCfQvFSR6tjRaS8llrnwZr2zt_KfxLqAp4',
    appId: '1:559631361002:ios:0e3459d65930055fe10893',
    messagingSenderId: '559631361002',
    projectId: 'smart-reclam',
    storageBucket: 'smart-reclam.appspot.com',
    iosBundleId: 'com.example.flutterApplication2.RunnerTests',
  );
}