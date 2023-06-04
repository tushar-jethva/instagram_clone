// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:instagram_clone/Models/comment_model.dart';
import 'package:instagram_clone/utills/constants.dart';
import 'package:provider/provider.dart';

import 'package:instagram_clone/Models/post_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/service/post_methods.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:instagram_clone/widgets/comment_card.dart';

class MyCommentScreen extends StatefulWidget {
  static const routeName = "/comment";
  final PostModel post;
  const MyCommentScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<MyCommentScreen> createState() => _MyCommentScreenState();
}

class _MyCommentScreenState extends State<MyCommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  void postComment({
    required String uid,
    required String comment,
    required String username,
    required String userPhoto,
  }) async {
    await PostMethods().postComment(
        postId: widget.post.postId,
        uid: uid,
        comment: comment,
        username: username,
        userPhoto: userPhoto);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Comments"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.post.postId)
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MyCommentCard(
                    comment:
                        CommentModel.fromMap(snapshot.data!.docs[index].data()),
                  );
                });
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                foregroundImage: CachedNetworkImageProvider(user.url),
              ),
              Gap(20),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Comment as ${user.username}",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 17)),
                ),
              ),
              TextButton(
                  onPressed: () {
                    if (_commentController.text.isEmpty) {
                      showSnackBar(
                          context: context, data: "Please write a comment!");
                    } else {
                      postComment(
                          uid: user.uid,
                          comment: _commentController.text,
                          username: user.username,
                          userPhoto: user.url);
                      _commentController.text = "";
                    }
                  },
                  child: Text("Post")),
            ],
          ),
        ),
      ),
    );
  }
}
