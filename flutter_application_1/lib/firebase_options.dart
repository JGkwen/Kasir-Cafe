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
    apiKey: 'AIzaSyCgzOPIFFkYcA1bdXQZYM-BO-MmD6mZpRE',
    appId: '1:573057856554:web:8b3336908c58e6bb147f53',
    messagingSenderId: '573057856554',
    projectId: 'fir-kasir-a96f4',
    authDomain: 'fir-kasir-a96f4.firebaseapp.com',
    storageBucket: 'fir-kasir-a96f4.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD37UElGBS4EwX6_zLLVF26TyMtQ17_J4o',
    appId: '1:573057856554:android:116822efb4453e53147f53',
    messagingSenderId: '573057856554',
    projectId: 'fir-kasir-a96f4',
    storageBucket: 'fir-kasir-a96f4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDz0mFmbMTLbFGRcGlcHg4vanE87rpt4H8',
    appId: '1:573057856554:ios:b5a362a3ed9c43a9147f53',
    messagingSenderId: '573057856554',
    projectId: 'fir-kasir-a96f4',
    storageBucket: 'fir-kasir-a96f4.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDz0mFmbMTLbFGRcGlcHg4vanE87rpt4H8',
    appId: '1:573057856554:ios:b5a362a3ed9c43a9147f53',
    messagingSenderId: '573057856554',
    projectId: 'fir-kasir-a96f4',
    storageBucket: 'fir-kasir-a96f4.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCgzOPIFFkYcA1bdXQZYM-BO-MmD6mZpRE',
    appId: '1:573057856554:web:968eeab8e086c3bd147f53',
    messagingSenderId: '573057856554',
    projectId: 'fir-kasir-a96f4',
    authDomain: 'fir-kasir-a96f4.firebaseapp.com',
    storageBucket: 'fir-kasir-a96f4.firebasestorage.app',
  );
}
