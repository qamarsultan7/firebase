import 'package:firebase/Screen/Auth/verify_code.dart';
import 'package:firebase/Utils/utils.dart';
import 'package:firebase/Widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final phonecontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
   String code='Code';
   String? pnonenumb;
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      favorite: ['PK'],
                      
                      context: context, onSelect: (velue) {
                     setState(() {
                        code='+${velue.phoneCode}';
                       
                     });
                    });
                  },
                  child: DropdownMenuItem(child: Row(
                    children: [
                      Text(code),
                      const Icon(Icons.arrow_drop_down_outlined)
                    ],
                  )),
                ),
                const SizedBox(width: 5,),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phonecontroller,
                    decoration:
                        const InputDecoration(hintText: ''),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
                loading: loading,
                title: 'Log In',
                ontap: () {
                  
                  setState(() {
                    loading = true;
                  });
                  auth.verifyPhoneNumber(
                      phoneNumber: '+$code${phonecontroller.text}',
                      verificationCompleted: (_) {},
                      verificationFailed: (e) {
                        final snackbar = Utils.createSnackBar(
                            e.toString(), Colors.red, const Icon(Icons.error));
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        setState(() {
                          loading = false;
                        });
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyCode(
                                      verificationid: verificationId,
                                    )));
                        setState(() {
                          loading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e) {
                        final snackbar = Utils.createSnackBar(
                            e.toString(), Colors.red, const Icon(Icons.error));
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        setState(() {
                          loading = false;
                        });
                      });
               
                })
          ],
        ),
      ),
    );
  }
}
