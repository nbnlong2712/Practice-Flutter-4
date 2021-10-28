import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flash_chat/login_screen.dart';
import 'package:flutter_flash_chat/sign_button.dart';
import 'package:flutter_flash_chat/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'chat_screen.dart';
import 'constant.dart' as Constant;

import 'info_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const router = "/register-screen";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loadProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: loadProgress,
          child: Container(
            alignment: Alignment.center,
            child: Container(
              width: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 170,
                    child: Hero(
                      tag: "logo",
                      child: Image.asset(
                        "images/bolt.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  InfoInput(
                    controller: usernameController,
                    isPassword: false,
                    hint: "Enter email",
                    icon: Icon(Icons.person),
                    inputType: TextInputType.emailAddress,
                  ),
                  InfoInput(
                    controller: passwordController,
                    isPassword: true,
                    hint: "Enter password",
                    icon: Icon(Icons.password),
                    inputType: TextInputType.text,
                  ),
                  SignButton(
                    tag: Constant.login,
                    label: Text(
                      Constant.register,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.lightBlue,
                    onPressed: () async {
                      setState(() {
                        loadProgress = true;
                      });

                      if(usernameController.text.isNotEmpty || passwordController.text.isNotEmpty)
                        {
                          setState(() {
                            loadProgress = false;
                          });
                          AppToast.showToast("Please fill enough information!");
                        }

                      try {
                        UserCredential userCredential =
                            await _auth.createUserWithEmailAndPassword(
                                email: usernameController.text,
                                password: passwordController.text);
                        if(userCredential != null)
                          {
                            setState(() {
                              loadProgress = false;
                            });
                            AppToast.showToast("Register success!");
                            Navigator.pushNamed(context, LoginScreen.router);
                          }
                        setState(() {
                          loadProgress = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          loadProgress = false;
                        });
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                          AppToast.showToast('The password provided is too weak');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                          AppToast.showToast('The account already exists for that email');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
