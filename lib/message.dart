import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  Message(
      {Key? key, required this.message,
      required this.textColor,
      required this.bubbleColor,
      required this.mainAxisAlignment,
      required this.alignment}) : super(key: key);

  String message;
  Color textColor;
  Color bubbleColor;
  MainAxisAlignment mainAxisAlignment;
  Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: bubbleColor),
              alignment: alignment,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
