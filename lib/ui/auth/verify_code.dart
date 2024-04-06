import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasealltutrorial/ui/post/post_screen.dart';
import 'package:firebasealltutrorial/utils/utiles.dart';
import 'package:firebasealltutrorial/widgets/round_button.dart';
import 'package:flutter/material.dart';

class VerfiyCode extends StatefulWidget {
  final String verificationId;

  const VerfiyCode({super.key, required this.verificationId});

  @override
  State<VerfiyCode> createState() => _VerfiyCodeState();
}

class _VerfiyCodeState extends State<VerfiyCode> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
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
              // keyboardType: TextInputType.number,
              controller: phoneNumber, decoration: InputDecoration(
                hintText: "6 Digits Code"
            ),
            ),
            SizedBox(height: 50),
            RoundButton(title: "Verify", loading: isLoading,
              onTap: () async {
              setState(() {
                isLoading= true;
              });
              final crendital = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: phoneNumber.text.toString());
              try{
                await auth.signInWithCredential(crendital);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PostScreen();
                },));
              }
                  catch(e)
              {
                setState(() {
                  isLoading= false;
                });
                Util().toastMeassage(e.toString());
              }
            },)
          ],
        ),
      ),
    );
  }
}
