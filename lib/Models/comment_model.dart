// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class CommentModel {
  final String username;
  final String userPhoto;
  final String comment;
  final String uid;
  final String postId;
  final datePublished;
  
  CommentModel({
    required this.username,
    required this.userPhoto,
    required this.comment,
    required this.uid,
    required this.postId,
    required this.datePublished
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'userPhoto': userPhoto,
      'comment': comment,
      'uid': uid,
      'postId': postId,
      'datePublished':datePublished
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      username: map['username'] as String,
      userPhoto: map['userPhoto'] as String,
      comment: map['comment'] as String,
      uid: map['uid'] as String,
      postId: map['postId'] as String,
      datePublished: map['datePublished']
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
