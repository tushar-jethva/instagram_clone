// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyProfileContainer extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isCurrUser;
  final bool isFollowed;
  const MyProfileContainer({
    Key? key,
    required this.text,
    required this.onTap,
    required this.isCurrUser,
    this.isFollowed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
            color: isCurrUser
                ? Colors.black
                : isFollowed
                    ? Colors.white
                    : Colors.blue,
            border: isCurrUser
                ? Border.all(color: Colors.grey, width: 1)
                : !isFollowed
                    ? Border.all(color: Colors.blue, width: 1)
                    : Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          text,
          style: isFollowed
              ? TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
              : TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
