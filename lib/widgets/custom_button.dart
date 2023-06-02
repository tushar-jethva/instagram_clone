import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const MyCustomButton(
      {super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
