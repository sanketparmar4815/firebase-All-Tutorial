import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasealltutrorial/utils/utiles.dart';
import 'package:firebasealltutrorial/widgets/round_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text(
          "Forgot Password",
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(), hintText: "Email"),
            ),
            const SizedBox(
              height: 40,
            ),
            RoundButton(
              title: "Forgot",
              onTap: () {
                auth.sendPasswordResetEmail(email: emailController.text.toString()).then(
                  (value) {
                    Util().toastMeassage("We have sent you email to recover password ,Please check email");
                  },
                ).onError(
                  (error, stackTrace) {
                    Util().toastMeassage(error.toString());
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
