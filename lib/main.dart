import 'package:firebase_core/firebase_core.dart';
import 'package:firebasealltutrorial/firebasapi.dart';
import 'package:firebasealltutrorial/ui/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(primarySwatch: Colors.deepPurple,),
      home: SplashScreen(),
      // home: SplashScreen(),
    );
  }
}
