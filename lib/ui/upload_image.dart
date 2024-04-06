import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasealltutrorial/ui/post/post_screen.dart';
import 'package:firebasealltutrorial/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/utiles.dart';
import 'auth/login_screen.dart';
import 'firestore/firestore_list_screen.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool isLoading = false;
  String imagepath = "";

  File? _image;
  final ImagePicker picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Image');

  Future getImagePick() async {
    final pickImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickImage != null) {
        _image = File(pickImage.path);
      } else {
        print("No Image Pick By User!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,

          title: const Center(
              child: Text(
            "Upload Image",
            style: TextStyle(color: Colors.white),
          )),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    )).onError((error, stackTrace) {
                      Util().toastMeassage(error.toString());
                    });
                  });
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 20,
            )
          ]),
      drawer: Drawer(backgroundColor: Colors.white,
        child: ListView(
          children: [
            ListTile(

              title: const Text('Realtime Database'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PostScreen();
                },));

              },
            ),
            ListTile(

              title: const Text('FireStore Database'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const FireStoreScreen();
                },));
              },
            ),
            ListTile(

              title: const Text('Uplorad Image'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const UploadImageScreen();
                },));
              },
            ),
          ],
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Center(
              child: InkWell(
                onTap: () {
                  getImagePick();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(
                          _image!.absolute,
                        )
                      : const Icon(Icons.image, size: 35),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              loading: isLoading,
              title: "Upload",
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref("/Image/" + id + ".jpg");
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(File(_image!.path));

                Future.value(uploadTask).then((value) async {
                  var newUrl = await ref.getDownloadURL();

                  databaseRef.child(id).set(
                      {'Id': id, 'Image': newUrl.toString()}).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    Util().toastMeassage('uploaded');
                  }).onError((error, stackTrace) {
                    print(error.toString());
                    setState(() {
                      isLoading = false;
                    });
                  });
                }).onError((error, stackTrace) {
                  Util().toastMeassage(error.toString());
                  setState(() {
                    isLoading = false;
                  });
                });

                //   },
                // );
              },
            )
          ],
        ),
      ),
    );
  }
}
