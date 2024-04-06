

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasealltutrorial/utils/utiles.dart';
import 'package:firebasealltutrorial/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {

  bool isLoading = false;
  TextEditingController postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection("Users");



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Firestore Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: "What is in your mind?",
                  border: OutlineInputBorder()),
              controller: postController,
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: "Add",
              loading: isLoading,
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();

                fireStore.doc(id).set({
                   "ID": id,
                  "Title" :postController.text.toString(),
                })
                    .then((value) {
                setState(() {
                isLoading = false;
                });
                postController.clear();
                  Util().toastMeassage("User add Successfully");

                },).onError((error, stackTrace) {
                setState(() {
                isLoading = true;
                });
                  Util().toastMeassage(error.toString());
                },);
              },
            )
          ],
        ),
      ),
    );
  }
}
