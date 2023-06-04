// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:instagram_clone/Models/user_model.dart';

class MyFavouriteScreen extends StatefulWidget {
  static const routeName = '/favourite';
  final UserModel user;
  const MyFavouriteScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MyFavouriteScreen> createState() => _MyFavouriteScreenState();
}

class _MyFavouriteScreenState extends State<MyFavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username),
      ),
    );
  }
}
