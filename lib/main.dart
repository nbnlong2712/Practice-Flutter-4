import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flash_chat/chat_screen.dart';
import 'package:flutter_flash_chat/login_screen.dart';
import 'package:flutter_flash_chat/register_screen.dart';
import 'package:flutter_flash_chat/welcome_screen.dart';

Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}
//
// void main()
// {
//   runApp(Main());
// }

class Main extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.router,
      home: WelcomeScreen(),
      routes: {
        ChatScreen.router: (context) => ChatScreen(),
        LoginScreen.router: (context) => LoginScreen(),
        WelcomeScreen.router: (context) => WelcomeScreen(),
        RegisterScreen.router: (context) => RegisterScreen(),
      },
    );
  }
}
