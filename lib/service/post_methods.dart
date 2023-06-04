import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/comment_model.dart';
import 'package:instagram_clone/Models/post_model.dart';
import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/service/storage_methods.dart';
import 'package:instagram_clone/utills/constants.dart';
import 'package:uuid/uuid.dart';

class PostMethods {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  uploadPost(
      {required String username,
      required String uid,
      required BuildContext context,
      required Uint8List file,
      required String desc,
      required String profileImage}) async {
    try {
      String url = await StorageServices()
          .uploadImagesInStorage(childName: "posts", file: file, isPost: true);

      String postId = const Uuid().v1();
      PostModel postModel = PostModel(
          username: username,
          desc: desc,
          uid: uid,
          postId: postId,
          url: profileImage,
          postUrl: url,
          datePublished: DateTime.now(),
          likes: []);
      await firebaseFirestore
          .collection("posts")
          .doc(postId)
          .set(postModel.toMap());

      showSnackBar(context: context, data: "Post uploaded");
      Navigator.pop(context);
    } catch (err) {
      showSnackBar(context: context, data: err.toString());
    }
  }

  Future<void> likePost(
      {required String postId,
      required String uid,
      required List likes}) async {
    try {
      if (likes.contains(uid)) {
        await firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString);
    }
  }

  postComment(
      {required String postId,
      required String uid,
      required String comment,
      required String username,
      required String userPhoto}) async {
    try {
      CommentModel commentModel = CommentModel(
          username: username,
          userPhoto: userPhoto,
          comment: comment,
          uid: uid,
          postId: postId,
          datePublished: DateTime.now());

      String commentId = const Uuid().v1();
      await firebaseFirestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(commentModel.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(
      {required String postId, required BuildContext context}) async {
    try {
      await firebaseFirestore.collection('posts').doc(postId).delete();
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
  }

  Future<UserModel> getUserDetails(
      {required BuildContext context, required String uid}) async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection('users').doc(uid).get();
    return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }
}
