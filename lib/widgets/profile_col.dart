// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyProfileColumn extends StatelessWidget {
  final String text1;
  final String text2;
  
  const MyProfileColumn({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text1,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(text2, style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
