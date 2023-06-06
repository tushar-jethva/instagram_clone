import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PostModel {
  final String username;
  final String desc;
  final String uid;
  final String postId;
  final String url;
  final String postUrl;
  final datePublished;
  final likes;
  final List bookMark;

  PostModel(
      {required this.username,
      required this.desc,
      required this.uid,
      required this.postId,
      required this.url,
      required this.postUrl,
      required this.datePublished,
      required this.likes,
      required this.bookMark});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'desc': desc,
      'uid': uid,
      'postId': postId,
      'url': url,
      'postUrl': postUrl,
      'datePublished': datePublished,
      'likes': likes,
      'bookMark':bookMark
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
        username: map['username'] as String,
        desc: map['desc'] as String,
        uid: map['uid'] as String,
        postId: map['postId'] as String,
        url: map['url'] as String,
        postUrl: map['postUrl'] as String,
        datePublished: map['datePublished'],
        likes: map['likes'],
        bookMark: map['bookMark']);
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
