import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasealltutrorial/ui/auth/login_with_phone_number.dart';
import 'package:firebasealltutrorial/ui/auth/signup_screen.dart';
import 'package:firebasealltutrorial/ui/forgot_password.dart';
import 'package:firebasealltutrorial/ui/post/post_screen.dart';
import 'package:firebasealltutrorial/utils/utiles.dart';
import 'package:firebasealltutrorial/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(child: Text("login screen"))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: email,
                        decoration: const InputDecoration(hintText: "Email"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: "password"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                loading: isLoading,
                title: "Login",
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email.text.toString(),
                        password: password.text.toString(),
                      );
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                         return PostScreen();
                      },));
                      //     .then((value) {
                      //   Util().toastMeassage(value.user!.email.toString());
                      //   setState(() {
                      //     isLoading = false;
                      //   });
                      //   Navigator.push(context, MaterialPageRoute(
                      //     builder: (context) {
                      //       return PostScreen();
                      //     },
                      //   ));
                      // }).onError((error, stackTrace) {
                      //   debugPrint(error.toString());
                      //   Util().toastMeassage(error.toString());
                      //   setState(() {
                      //     isLoading = false;
                      //   });
                      // });
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      print(e.message);
                      print(e.credential);

                      setState(() {
                        isLoading = false;
                      });
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        Util().toastMeassage(e.code.toString());
                      } else if (e.code == 'wrong-password') {
                        Util().toastMeassage(e.code.toString());
                        print('Wrong password provided for that user.');
                      }
                    }
                  }
                },
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ForgotPasswordScreen();
                        },
                      ));
                    },
                    child: const Text("Forgot Password?")),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(child: Text("Don't have an  account?")),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return SignupScreen();
                          },
                        ));
                      },
                      child: const Text("Sign up")),

                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginWithPhoneNumber();
                  },));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: const Center(
                    child: Text("Login With Phone Number"),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
