import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_flash_chat/chat_screen.dart';
import 'package:flutter_flash_chat/sign_button.dart';
import 'package:flutter_flash_chat/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'constant.dart' as Constant;
import 'info_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const router = "/login-screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loadProgress = false;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      Navigator.pushNamed(context, ChatScreen.router);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: loadProgress,
          child: WillPopScope(
            onWillPop: () async {
              setState(() {
                loadProgress = false;
              });
              return true;
            },
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
                      controller: emailController,
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
                        Constant.login,
                        style: TextStyle(fontSize: 18),
                      ),
                      color: Colors.lightBlueAccent,
                      onPressed: () async {
                        setState(() {
                          loadProgress = true;
                        });
                        if(emailController.text.isEmpty || passwordController.text.isEmpty)
                          {
                            AppToast.showToast("Please fill enough information!");
                            setState(() {
                              loadProgress = false;
                            });
                          }
                        else {
                          try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);
                          if (userCredential != null) {
                            setState(() {
                              loadProgress = false;
                            });
                            AppToast.showToast("Sign in success!");
                            Navigator.pushNamedAndRemoveUntil(
                                context, ChatScreen.router, (r) => false);
                          }
                          setState(() {
                            loadProgress = false;
                          });
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            loadProgress = false;
                          });
                          if (e.code == 'user-not-found') {
                            AppToast.showToast('No user found for that email');
                          } else if (e.code == 'wrong-password') {
                            AppToast.showToast(
                                'Wrong password provided for that user');
                          }
                        }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
