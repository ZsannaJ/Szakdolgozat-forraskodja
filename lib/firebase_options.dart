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
    apiKey: 'AIzaSyB9jlEdiRRgiIvlcTMx7ECGKZEjzEeNJT4',
    appId: '1:350462276580:web:4b66c99c2b217fe785cdf1',
    messagingSenderId: '350462276580',
    projectId: 'toprank-46653',
    authDomain: 'toprank-46653.firebaseapp.com',
    storageBucket: 'toprank-46653.firebasestorage.app',
    measurementId: 'G-XSDTZ50CBZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAPEtAD87wQnMCkBHwULKRbv_i47kVCmw',
    appId: '1:350462276580:android:67d87eefe937ff7e85cdf1',
    messagingSenderId: '350462276580',
    projectId: 'toprank-46653',
    storageBucket: 'toprank-46653.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeGzy9f6ma6PHj0OuFTAs2omhEamWWoXk',
    appId: '1:350462276580:ios:19962d2512d56ce585cdf1',
    messagingSenderId: '350462276580',
    projectId: 'toprank-46653',
    storageBucket: 'toprank-46653.firebasestorage.app',
    iosBundleId: 'com.example.ranker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAeGzy9f6ma6PHj0OuFTAs2omhEamWWoXk',
    appId: '1:350462276580:ios:19962d2512d56ce585cdf1',
    messagingSenderId: '350462276580',
    projectId: 'toprank-46653',
    storageBucket: 'toprank-46653.firebasestorage.app',
    iosBundleId: 'com.example.ranker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB9jlEdiRRgiIvlcTMx7ECGKZEjzEeNJT4',
    appId: '1:350462276580:web:dcfda434de02f74685cdf1',
    messagingSenderId: '350462276580',
    projectId: 'toprank-46653',
    authDomain: 'toprank-46653.firebaseapp.com',
    storageBucket: 'toprank-46653.firebasestorage.app',
    measurementId: 'G-XB1QDK8H5W',
  );
}
