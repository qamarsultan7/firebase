// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Screen/Firestore/add_data.dart';
import 'package:firebase/Utils/utils.dart';
import 'package:firebase/Screen/Auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({Key? key}) : super(key: key);

  @override
  State<FirestoreScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<FirestoreScreen> {
  TextEditingController filtercontroller = TextEditingController();
  TextEditingController editcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('Users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Firestore Screen'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  final snackbar = Utils.createSnackBar(
                      error.toString(), Colors.red, const Icon(Icons.error));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                });
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (cotext) => const AddFirestoreData()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 10),
            child: TextFormField(
              controller: filtercontroller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Search'),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text('Some Error');
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Text('No More Data');
                }
                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              ref
                                  .doc(snapshot.data!.docs[index]['id']
                                      .toString())
                                  .delete();
                              setState(() {});
                            },
                            title: Text(
                                snapshot.data!.docs[index]['title'].toString()),
                            subtitle: Text(
                                snapshot.data!.docs[index]['id'].toString()),
                          );
                        }));
              })
        ],
      ),
    );
  }

  Future<void> showmyDialougeBox(String title, id) {
    editcontroller.text = title;
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              maxLines: 5,
              controller: editcontroller,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(onPressed: () {}, child: const Text('Update'))
            ],
          );
        }));
  }
}
