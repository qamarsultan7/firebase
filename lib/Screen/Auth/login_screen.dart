import 'dart:async';

import 'package:firebase/Screen/Auth/login_with_phone.dart';
import 'package:firebase/Screen/Post/post_Screen.dart';
import 'package:firebase/Screen/Auth/signup_creeen.dart';
import 'package:firebase/Utils/utils.dart';
import 'package:firebase/Widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formlKey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
    _passwordController.dispose();
  }

  void logInUp() {
    try {
      _auth
          .signInWithEmailAndPassword(
        email: _emailcontroller.text.toString(),
        password: _passwordController.text.toString(),
      )
          .then((value) {
        setState(() {
          loading = false;
        });
        debugPrint(value.user!.email.toString());
        final snackbar = Utils.createSnackBar(
            'Login Sucesssfully', Colors.green, const Icon(Icons.done_all));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Timer(const Duration(seconds: 2), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PostScreen()));
        });
      }).onError((error, stackTrace) {
        setState(() {
          loading = false;
        });
        final snackbar = Utils.createSnackBar(
            error.toString(), Colors.red, const Icon(Icons.error));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: const Text('Login Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formlKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                title: 'Log In',
                loading: loading,
                ontap: () {
                  setState(() {
                    loading = true;
                  });
                  if (_formlKey.currentState!.validate()) {
                    logInUp();
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },
                      child: const Text('Sign Up'))
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginWithPhone()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white)),
                  child: const Text(
                    'Log in with PhoneNumber',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
