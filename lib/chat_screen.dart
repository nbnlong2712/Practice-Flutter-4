import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flash_chat/login_screen.dart';

import 'message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const String router = "/chat-screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  final _firebaseStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? firebaseUser;

  void checkUser() {
    final user = _auth.currentUser;
    if (user == null) {
      // ignore: avoid_print
      print("User is null!");
      Navigator.pushNamed(context, LoginScreen.router);
    } else {
      firebaseUser = user;
      // ignore: avoid_print
      print(firebaseUser?.email);
    }
  }

  void getData() async {
    await for (var snapshot
        in _firebaseStore.collection("messages").snapshots()) {
      for (var message in snapshot.docs) {
        // ignore: avoid_print
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat"),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.router, (r) => false);
              },
              icon: const Icon(
                Icons.logout,
              )),
        ],
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firebaseStore.collection("messages").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final message = snapshot.data?.docs;
                        List<Widget> messageList = [];
                        for (var mess in message!) {
                          Widget messageWidget;
                          if (mess.get("sender") ==
                              firebaseUser!.email.toString()) {
                            //Bubble message from sender
                            messageWidget = Message(
                              message: mess.get("text"),
                              textColor: Colors.white,
                              bubbleColor: Colors.lightBlue,
                              mainAxisAlignment: MainAxisAlignment.end,
                              alignment: Alignment.centerRight,
                            );
                          } else {
                            messageWidget = Message(
                                message: mess.get("text"),
                                textColor: Colors.black,
                                bubbleColor: Colors.black12,
                                mainAxisAlignment: MainAxisAlignment.start,
                                alignment: Alignment.centerLeft);
                          }
                          messageList.add(messageWidget);
                        }
                        return Center(
                          child: ListView(
                            children: messageList,
                          ),
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.lightBlueAccent,
                        ));
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.lightBlueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: messageController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Type your message here...",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        suffixIcon: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (messageController.text.trim().isNotEmpty) {
                              _firebaseStore.collection("messages").add({
                                "sender": firebaseUser?.email,
                                "text": messageController.text.trim(),
                              });
                            }
                            messageController.text = "";
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
