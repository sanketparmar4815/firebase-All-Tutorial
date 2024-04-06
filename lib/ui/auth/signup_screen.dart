import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasealltutrorial/ui/auth/login_screen.dart';
import 'package:firebasealltutrorial/utils/utiles.dart';
import 'package:firebasealltutrorial/widgets/round_button.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool isLoading =false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

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
      appBar: AppBar(title: const Center(child: Text("SignUp screen"))),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                title: "Sign up",
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    // _auth.createUserWithEmailAndPassword(
                    //     email: email.text.toString(),
                    //     password: password.text.toString());
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: email.text.toString(),
                            password: password.text.toString(),
                          )
                          .then((value) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            },));
                        setState(() {
                          isLoading = false;
                        });
                      })
                          .onError((error, stackTrace) {
                        Util().toastMeassage(error.toString());
                        setState(() {
                          isLoading = false;
                        });
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        Util().toastMeassage(e.toString());
                      } else if (e.code == 'email-already-in-use') {
                        Util().toastMeassage(e.toString());
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(child: Text("Already  have an  account?")),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ));
                      },
                      child: const Text("Login"))
                ],
              ),
            ]),
      ),
    );
  }
}
