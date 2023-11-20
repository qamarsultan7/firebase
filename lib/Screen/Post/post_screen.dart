// ignore_for_file: library_private_types_in_public_api

import 'package:firebase/Screen/Post/add_post.dart';
import 'package:firebase/Utils/utils.dart';
import 'package:firebase/Screen/Auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController filtercontroller = TextEditingController();
  TextEditingController editcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Post Screen'),
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
          Navigator.push(
              context, MaterialPageRoute(builder: (cotext) => const AddPost()));
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
          Expanded(
              child: StreamBuilder(
                  stream: ref.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final dynamic data = snapshot.data!.snapshot.value;
                    if (data == null) {
                      return const Center(
                        child: Text('Nothing Post'),
                      );
                    } else if (data is Map<dynamic, dynamic>) {
                      List<dynamic> postList = data.values.toList();

                      return ListView.builder(
                          itemCount: snapshot.data!.snapshot.children.length,
                          itemBuilder: (context, index) {
                            final post = postList[index]['name'].toString();
                            if (filtercontroller.text.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  tileColor: Colors.grey,
                                  title: Text(postList[index]['name']),
                                  trailing: PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                                value: 1,
                                                child: ListTile(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      showmyDialougeBox(
                                                        postList[index]['name'],
                                                        postList[index]['id'],
                                                      );
                                                    },
                                                    leading:
                                                        const Icon(Icons.edit),
                                                    title: const Text('Edit'))),
                                            PopupMenuItem(
                                                value: 2,
                                                onTap: () {
                                                  
                                                  ref.child(postList[index]['id']).remove().then((value) {
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: const ListTile(
                                                    leading: Icon(Icons.delete),
                                                    title: Text('Delete')))
                                          ]),
                                ),
                              );
                            } else if (post.toLowerCase().contains(
                                filtercontroller.text
                                    .toString()
                                    .toLowerCase())) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  tileColor:
                                      const Color.fromARGB(172, 237, 202, 76),
                                  title: Text(postList[index]['name']),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return const Text('Unexpected error');
                    }
                  })),
          // Expanded(
          //   child: FirebaseAnimatedList(
          //       query: ref,
          //       itemBuilder: (context, snapshot, animation, index) {
          //         return Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Card(
          //             color: Colors.teal,
          //             elevation: 4,
          //             shadowColor: Colors.yellow,
          //             child: Padding(
          //               padding: const EdgeInsets.all(20.0),
          //               child: Text(snapshot.child('name').value.toString()),
          //             ),
          //           ),
          //         );
          //       }),
          // )
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
              TextButton(
                  onPressed: () {
                    ref.child(id).update(
                        {'name': editcontroller.text.toString()}).then((value) {
                      final snackbar = Utils.createSnackBar(
                          'Updated', Colors.green, const Icon(Icons.done_all));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }).onError((error, stackTrace) {
                      final snackbar = Utils.createSnackBar(error.toString(),
                          Colors.green, const Icon(Icons.done_all));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Update'))
            ],
          );
        }));
  }
}
