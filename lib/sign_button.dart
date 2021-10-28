import 'package:flutter/material.dart';

class SignButton extends StatelessWidget {
  const SignButton({Key? key,
    required this.onPressed,
    required this.label,
    required this.color,
    required this.tag})
      : super(key: key);

  final Function() onPressed;
  final Text label;
  final String tag;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: FloatingActionButton.extended(
        heroTag: tag,
        onPressed: onPressed,
        label: label,
        backgroundColor: color,
      ),
    );
  }
}
