// ignore_for_file: use_build_context_synchronously

import 'package:firebase/Screen/Post/post_Screen.dart';
import 'package:firebase/Utils/utils.dart';
import 'package:firebase/Widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCode extends StatefulWidget {
  final String verificationid;
  const VerifyCode({Key? key, required this.verificationid}) : super(key: key);

  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final codecontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In with Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            SizedBox(
              width: double.infinity,
             
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: codecontroller,
                decoration: const InputDecoration(
                   
                    hintText: '6 Digit Code'),
                    textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
                loading: loading,
                title: 'Verify',
                ontap: () async {
                  setState(() {
                    loading=true;
                  });
                  final credentials = PhoneAuthProvider.credential(
                      verificationId: widget.verificationid,
                      smsCode: codecontroller.text.toString());
                  try {
                    await auth.signInWithCredential(credentials);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const PostScreen()));
                  } catch (e) {
                    setState(() {
                      loading=false;
                    });
                    final snackbar=Utils.createSnackBar(e.toString(), Colors.red, const Icon(Icons.error));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                })
          ],
        ),
      ),
    );
  }
}
