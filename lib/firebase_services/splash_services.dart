import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasealltutrorial/ui/auth/login_screen.dart';
import 'package:firebasealltutrorial/ui/firestore/firestore_list_screen.dart';
import 'package:firebasealltutrorial/ui/post/post_screen.dart';
import 'package:firebasealltutrorial/ui/upload_image.dart';
import 'package:flutter/material.dart';

class SplashService
{
void isLogin(BuildContext context)
{
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  if(user != null)
    {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const PostScreen();
          // return const FireStoreScreen();
          // return const UploadImageScreen();
        },));
      });
    }
  else {
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const LoginScreen();
      },));
    });
  }
}
}