// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:instagram_clone/service/post_methods.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:instagram_clone/utills/constants.dart';
import 'package:provider/provider.dart';

import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';

class MyAddPostScreen extends StatefulWidget {
  static const routeName = "/addpost";
  final Uint8List image;
  const MyAddPostScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<MyAddPostScreen> createState() => _MyAddPostScreenState();
}

class _MyAddPostScreenState extends State<MyAddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool isLoad = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _captionController.dispose();
  }

  void uploadPost({
    required String username,
    required String uid,
    required String photoUrl
  }) async {
    setState(() {
      isLoad = true;
    });
    await PostMethods().uploadPost(
        username: username,
        uid: uid,
        profileImage: photoUrl,
        context: context,
        file: widget.image,
        desc: _captionController.text);
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context, listen: false).user;
    print("user is" + user.url);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Post to"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          TextButton(
              onPressed: () {
                uploadPost(uid: user.uid, username: user.username,photoUrl: user.url);
              },
              child: const Text(
                "Post",
                style: TextStyle(fontSize: 17),
              ))
        ],
      ),
      body: Column(
        children: [
          isLoad
              ? LinearProgressIndicator(
                  color: Colors.blue,
                )
              : Container(),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 27,
                    foregroundImage: NetworkImage(user.url),
                  ),
                  Gap(20),
                  Expanded(
                    child: TextField(
                      maxLines: 4,
                      controller: _captionController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Write a caption..."),
                    ),
                  ),
                  Gap(10),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(widget.image),
                            fit: BoxFit.cover)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
