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
    apiKey: 'AIzaSyAdcZmJVQMUFo4jQy0lAUcRBGN3fgXWczs',
    appId: '1:705909887183:web:050f482b2f54221c3627ba',
    messagingSenderId: '705909887183',
    projectId: 'staton-9a0a2',
    authDomain: 'staton-9a0a2.firebaseapp.com',
    databaseURL: 'https://staton-9a0a2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'staton-9a0a2.appspot.com',
    measurementId: 'G-41S9Y9XJBE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNx5qCkTp0fea2vVz2jzco_O39YXv4SrU',
    appId: '1:705909887183:android:098dc011e048e8c93627ba',
    messagingSenderId: '705909887183',
    projectId: 'staton-9a0a2',
    databaseURL: 'https://staton-9a0a2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'staton-9a0a2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAISanaehs7_1u7NnlkldQFnIlJim2P0CY',
    appId: '1:705909887183:ios:65db75666620d6ff3627ba',
    messagingSenderId: '705909887183',
    projectId: 'staton-9a0a2',
    databaseURL: 'https://staton-9a0a2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'staton-9a0a2.appspot.com',
    iosClientId: '705909887183-9vgdkgl5ke71a0dva4rg8dpjgtaa6jhv.apps.googleusercontent.com',
    iosBundleId: 'com.example.staton',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAISanaehs7_1u7NnlkldQFnIlJim2P0CY',
    appId: '1:705909887183:ios:65db75666620d6ff3627ba',
    messagingSenderId: '705909887183',
    projectId: 'staton-9a0a2',
    databaseURL: 'https://staton-9a0a2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'staton-9a0a2.appspot.com',
    iosClientId: '705909887183-9vgdkgl5ke71a0dva4rg8dpjgtaa6jhv.apps.googleusercontent.com',
    iosBundleId: 'com.example.staton',
  );
}
