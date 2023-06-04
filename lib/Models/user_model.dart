import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String username;
  final String bio;
  final String email;
  final String url;
  final String uid;
  final List followers;
  final List following;
  UserModel({
    required this.username,
    required this.bio,
    required this.email,
    required this.url,
    required this.uid,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'bio': bio,
      'email': email,
      'url': url,
      'uid': uid,
      'followers': followers,
      'following': following,
    };
  }

   
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      bio: map['bio'] as String,
      email: map['email'] as String,
      url: map['url'] as String,
      uid: map['uid'] as String,
      followers: List.from((map['followers'] as List)),
      following: List.from((map['following'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
