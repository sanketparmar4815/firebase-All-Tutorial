import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Util
{
void toastMeassage(String meassage)
{
  Fluttertoast.showToast(
      msg: meassage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.deepPurple.shade300,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
}