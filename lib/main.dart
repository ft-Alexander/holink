import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:holink/features/authentication/views/login.dart';
// import 'package:firebase_core/firebase_core.dart';

// Future main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(HolinkApp())
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAzVOWqd4hPdUBmag87ujvszm3jd8miiT4",
          authDomain: "holink-69aed.firebaseapp.com",
          projectId: "holink-69aed",
          storageBucket: "holink-69aed.appspot.com",
          messagingSenderId: "184456395100",
          appId: "1:184456395100:web:431f3de381aaba7d7b6999"));

  runApp(const HolinkApp());
}

class HolinkApp extends StatelessWidget {
  const HolinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}
