import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasealltutrorial/ui/auth/login_screen.dart';
import 'package:firebasealltutrorial/ui/firestore/firestore_list_screen.dart';
import 'package:firebasealltutrorial/ui/post/add_post.dart';
import 'package:firebasealltutrorial/ui/upload_image.dart';
import 'package:firebasealltutrorial/utils/utiles.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Post");
  TextEditingController search = TextEditingController();
  TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          // automaticallyImplyLeading: false,
          title: const Center(
              child: Text(
            "Post",
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
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            ListTile(
              title: const Text('Realtime Database'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const PostScreen();
                  },
                ));
              },
            ),
            ListTile(
              title: const Text('FireStore Database'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const FireStoreScreen();
                  },
                ));
              },
            ),
            ListTile(
              title: const Text('Uplorad Image'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const UploadImageScreen();
                  },
                ));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return AddPostScreen();
              },
            ));
          },
          child: const Icon(Icons.add)),
      body: Column(
        children: [
          // this is stramBulider Method below

          // Expanded(
          //     child: StreamBuilder(
          //   stream: ref.onValue,
          //   builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {
          //     if(!snapshot.hasData)
          //       {
          //         return CircularProgressIndicator();
          //       }
          //     else
          //       {
          //         Map<dynamic ,dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //         List<dynamic> list = [];
          //         list.clear();
          //        list = map.values.toList();
          //         return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(list[index]['Title']),
          //             );
          //           },
          //         );
          //
          //       }
          //   },
          // )),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: search,
              decoration: const InputDecoration(
                  hintText: "Search", border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Text("Loading"),
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child("Title").value.toString();

                if (search.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child("Title").value.toString()),
                    subtitle: Text(snapshot.child("Id").value.toString()),
                    trailing: PopupMenuButton(
                      elevation: 4,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 1,
                            onTap: () {
                              // Navigator.of(context).pop();
                              showMyDialog(
                                  title, snapshot.child("Id").value.toString());
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
                                  .child(snapshot.child("Id").value.toString())
                                  .remove();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.delete),
                              title: Text("Delete"),
                            )),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(search.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child("Title").value.toString()),
                    subtitle: Text(snapshot.child("Id").value.toString()),
                  );
                } else {
                  return Container();
                }
              },
            ),
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
          title: Text("Update"),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(
                hintText: "Edit Here",
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.of(context).pop();
                  ref.child(Id).update({
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
                child: Text('Update'))
          ],
        );
      },
      context: context,
    );
  }
}
