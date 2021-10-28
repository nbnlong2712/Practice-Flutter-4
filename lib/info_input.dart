import 'package:flutter/material.dart';

class InfoInput extends StatelessWidget {
  const InfoInput(
      {Key? key,
      required this.controller,
      required this.hint,
      required this.icon,
      required this.inputType,
      required this.isPassword})
      : super(key: key);

  final TextEditingController controller;
  final String hint;
  final Icon icon;
  final TextInputType inputType;
  final isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: TextField(
        obscureText: isPassword,
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: icon,
        ),
      ),
    );
  }
}
