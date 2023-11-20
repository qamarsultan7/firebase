// ignore_for_file: avoid_print

import 'package:firebase/Widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({Key? key}) : super(key: key);

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  bool loading = false;
  final postcontroller = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add FireStoreData'),
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
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  firestore.doc(id).set({
                    'id':id,
                    'title': postcontroller.text.toString(),
                    
                  }).then((value) {
                    postcontroller.clear();
                    setState(() {
                      loading=false;
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading=false;
                    });
                    print(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
