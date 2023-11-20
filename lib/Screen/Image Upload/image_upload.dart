// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:firebase/Widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key}) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  firebase_storage.SettableMetadata metadata =
      firebase_storage.SettableMetadata(
    contentType: 'image/jpeg',
  );
  Future selectFile() async {
    final pickedfile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedfile != null) {
        _image = File(pickedfile.path);
      } else {
        print('No image Selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Upload Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: InkWell(
            onTap: () {
              selectFile();
            },
            child: Container(
              height: 200,
              width: 200,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: _image != null
                  ? Image.file(_image!.absolute)
                  : const Icon(Icons.image),
            ),
          )),
          const SizedBox(
            height: 50,
          ),
          RoundButton(
              title: 'Upload',
              loading: loading,
              ontap: () {
                setState(() {
                  loading = true;
                });
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/QamarSultan/' ).child(DateTime.now().millisecondsSinceEpoch.toString());
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(_image!.absolute,metadata);
                Future.value(uploadTask).then((value) async {
                  setState(() {
                    loading = false;
                  });
                  print('Uploaded');
                  print(await ref.getDownloadURL());
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  print(error.toString());
                });
              })
        ],
      ),
    );
  }
}
