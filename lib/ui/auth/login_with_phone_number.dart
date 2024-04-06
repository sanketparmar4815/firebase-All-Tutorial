import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasealltutrorial/ui/auth/verify_code.dart';
import 'package:firebasealltutrorial/utils/utiles.dart';
import 'package:firebasealltutrorial/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool isLoading =false;
  TextEditingController phoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: phoneNumber,decoration: InputDecoration(
              hintText: "+1 123 4567 890"
            ),
            ),
            SizedBox(height: 50),
            RoundButton(title: "login", loading: isLoading,
            onTap: () async {
              setState(() {
                isLoading =true;
              });
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: "+91 ${phoneNumber.text}",
                verificationCompleted: (_) {setState(() {
                  isLoading =false;
                });

                },
                verificationFailed: (FirebaseAuthException e) {
                  setState(() {
                    isLoading =false;
                  });
                  Util().toastMeassage(e.toString());
                },
                codeSent: (String verificationId, int? resendToken) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return VerfiyCode(verificationId: verificationId,);

                  },));
                  setState(() {
                    isLoading =false;
                  });
                },
                codeAutoRetrievalTimeout: (e) {
                  Util().toastMeassage(e.toString());
                  setState(() {
                    isLoading =false;
                  });
                },
              );

            },)
          ],
        ),
      ),
    );
  }
}
