import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasealltutrorial/ui/auth/login_screen.dart';
import 'package:firebasealltutrorial/ui/firestore/add_firestore_data.dart';
import 'package:firebasealltutrorial/ui/post/post_screen.dart';
import 'package:firebasealltutrorial/utils/utiles.dart';
import 'package:flutter/material.dart';

import '../upload_image.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  // TextEditingController search = TextEditingController();
  TextEditingController editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection("Users").snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,

          title: const Center(
              child: Text(
            "FireStore",
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
      drawer: Drawer(
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const AddFirestoreDataScreen();
              },
            ));
          },
          child: const Icon(Icons.add)),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Text("Some error");
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {

                    return ListTile(

                      title:
                          Text(snapshot.data!.docs[index]["Title"].toString()),
                      subtitle:
                          Text(snapshot.data!.docs[index]["ID"].toString()),
                      trailing: PopupMenuButton(
                        elevation: 4,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              onTap: () {
                                // Navigator.of(context).pop();
                                showMyDialog(
                                    snapshot.data!.docs[index]["Title"]
                                        .toString(),
                                    snapshot.data!.docs[index]["ID"]
                                        .toString());
                              },
                              child: const ListTile(
                                leading: Icon(Icons.edit),
                                title: Text("Edit"),
                              )),
                          PopupMenuItem(
                              value: 2,
                              onTap: () {
                                // Navigator.of(context).pop();
                                ref
                                    .doc(snapshot.data!.docs[index]["ID"]
                                        .toString())
                                    .delete();
                              },
                              child: const ListTile(
                                leading: Icon(Icons.delete),
                                title: Text("Delete"),
                              )),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String Id) async {
    editController.text = title;
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: const Text("Update"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: "Edit Here",
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.of(context).pop();
                },
                child:const  Text('Cancel')),
            TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.of(context).pop();

                  ref.doc(Id).update({
                    "Title": editController.text.toString(),
                  }).then(
                    (value) {
                      Util().toastMeassage("Post Updated");
                    },
                  ).onError(
                    (error, stackTrace) {
                      Util().toastMeassage(error.toString());
                    },
                  );
                },
                child: const Text('Update'))
          ],
        );
      },
      context: context,
    );
  }
}
