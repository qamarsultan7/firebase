import 'package:firebase/Utils/utils.dart';
import 'package:firebase/Widgets/round_button.dart';
import 'package:firebase/Screen/Auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  void signUp() {
    try {
      _auth
          .createUserWithEmailAndPassword(
        email: _emailcontroller.text.toString(),
        password: _passwordController.text.toString(),
      )
          .then((value) {
        setState(() {
          loading = false;
        });
        final snackbar = Utils.createSnackBar('Account Created Sucesssfully',
            Colors.green, const Icon(Icons.done_all));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Sign up Screen'),
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
              title: 'Sign Up',
              loading: loading,
              ontap: () {
                setState(() {
                  loading = true;
                });
                if (_formlKey.currentState!.validate()) {
                  signUp();
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Login'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
