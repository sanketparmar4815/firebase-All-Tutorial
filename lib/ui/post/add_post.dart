import 'package:firebase_database/firebase_database.dart';
import 'package:firebasealltutrorial/utils/utiles.dart';
import 'package:firebasealltutrorial/widgets/round_button.dart';
import 'package:flutter/material.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  // TextEditingController  = TextEditingController();
  bool isLoading = false;


  // final storageRef = FirebaseStorage.instance.ref('Post');
  DatabaseReference storageRef = FirebaseDatabase.instance.ref().child("Post");
  TextEditingController postController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add post"),
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
                DatabaseReference ref = storageRef.push();
String id =  DateTime.now().millisecondsSinceEpoch.toString() ;
                // String? id = ref.key;
                storageRef.child(id).set({
                // ref.set({
                  "Id": id,
                  "Title": postController.text.toString(),
                }).then((value) {
                  print("${ref.path}  ");

                  postController.clear();
                  setState(() {
                    isLoading = false;

                  });
                  Util().toastMeassage("Post Added..");
                }).onError(
                  (error, stackTrace) {
                    setState(() {
                      isLoading = true;
                    });
                    Util().toastMeassage(error.toString());
                  },
                );

                // await ref.set({
                //   "Title": postController.text.toString(),
                // });
              },
            )
          ],
        ),
      ),
    );
  }

}
