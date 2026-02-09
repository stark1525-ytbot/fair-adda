import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCR3EJS0UvnUvARgnM5MB86sCUIe4XN-AU',
    appId: '1:822174456790:android:1c902ba7aae12994726277',
    messagingSenderId: '822174456790',
    projectId: 'gamer-954c4',
    databaseURL: 'https://gamer-954c4-default-rtdb.firebaseio.com',
    storageBucket: 'gamer-954c4.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAky4Ic6Yl5AVzEh7B-RdClghQPxzcIS_c',
    appId: '1:822174456790:web:806e2dd05bf8ae67726277',
    messagingSenderId: '822174456790',
    projectId: 'gamer-954c4',
    authDomain: 'gamer-954c4.firebaseapp.com',
    databaseURL: 'https://gamer-954c4-default-rtdb.firebaseio.com',
    storageBucket: 'gamer-954c4.firebasestorage.app',
    measurementId: 'G-JR99672DBT',
  );

}