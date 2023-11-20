import 'package:firebase/Widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool loading = false;
  final databse = FirebaseDatabase.instance.ref('Post');
  final postcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
        child: Column(
          children: [
            TextFormField(
              controller: postcontroller,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: 'What\'s in your mind',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
                loading: loading,
                title: 'Add Data',
                ontap: () {
                 String id=DateTime.now().millisecondsSinceEpoch.toString();
                  databse.child(id).set({
                    'name': postcontroller.text.toString(),
                    'id':id
                    });
                 postcontroller.clear();
                })
          ],
        ),
      ),
    );
  }
}
