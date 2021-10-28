import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flash_chat/chat_screen.dart';
import 'package:flutter_flash_chat/register_screen.dart';
import 'package:flutter_flash_chat/sign_button.dart';

import 'constant.dart' as Constant;
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const String router = "/welcome-screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late Animation colorAnimation;
  late FirebaseAuth _auth;
  User? user;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;

    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInCubic);
    colorAnimation =
        ColorTween(begin: Colors.lightBlueAccent, end: Colors.white)
            .animate(controller);

    controller.forward();

    // animation.addStatusListener((status) {
    //   if(status == AnimationStatus.completed)
    //     controller.reverse(from: 1.0);
    //   else if(status == AnimationStatus.dismissed)
    //     controller.forward(from: 0.0);
    // });

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAnimation.value,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Container(
            width: 700,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Hero(
                        tag: "logo",
                        child: Image.asset("images/bolt.png"),
                      ),
                      height: 100.0 * animation.value,
                    ),
                    AnimatedTextKit(
                      onTap: null,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Flash chat",
                          textStyle: TextStyle(
                            fontSize: 47,
                            fontWeight: FontWeight.w900,
                          ),
                          speed: Duration(milliseconds: 125),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 45,
                ),
                SignButton(
                  tag: Constant.login,
                  label: Text(
                    Constant.login,
                    style: TextStyle(fontSize: 18),
                  ),
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    if (user == null)
                      Navigator.pushNamed(context, LoginScreen.router);
                    else{
                      Navigator.pushNamedAndRemoveUntil(context, ChatScreen.router, (route) => false);
                    }
                  },
                ),
                SignButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.router);
                  },
                  label: Text(
                    Constant.register,
                    style: TextStyle(fontSize: 18),
                  ),
                  color: Colors.lightBlue,
                  tag: Constant.register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
