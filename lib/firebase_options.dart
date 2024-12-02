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
    apiKey: 'AIzaSyDrTvNJgbhKRr5MM0bTVj7EJCidSKENSwQ',
    appId: '1:600417777800:android:77fa5e0b55c059a77a073d',
    messagingSenderId: '600417777800',
    projectId: 'chitter-chatter-85ddf',
    storageBucket: 'chitter-chatter-85ddf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0Z91sl9fRpbVZeXSArIR7B6my9KXCYWk',
    appId: '1:600417777800:ios:eaa227e35bd2ba0d7a073d',
    messagingSenderId: '600417777800',
    projectId: 'chitter-chatter-85ddf',
    storageBucket: 'chitter-chatter-85ddf.appspot.com',
    iosBundleId: 'com.example.chitterChatter',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCLAuIcd7eVNYPAJ1g59kIRnzbOljhUmzM',
    appId: '1:600417777800:web:199249262edcf9827a073d',
    messagingSenderId: '600417777800',
    projectId: 'chitter-chatter-85ddf',
    authDomain: 'chitter-chatter-85ddf.firebaseapp.com',
    storageBucket: 'chitter-chatter-85ddf.appspot.com',
    measurementId: 'G-KTTLNVYH9C',
  );

}