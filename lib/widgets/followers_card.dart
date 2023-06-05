// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/service/post_methods.dart';
import 'package:instagram_clone/widgets/profile_container.dart';

class MyFollowersCard extends StatefulWidget {
  final String originalId;
  final String id;
  const MyFollowersCard({
    Key? key,
    required this.originalId,
    required this.id,
  }) : super(key: key);

  @override
  State<MyFollowersCard> createState() => _MyFollowersCardState();
}

class _MyFollowersCardState extends State<MyFollowersCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .snapshots()
        .listen((event) => getData());
  }

  UserModel? user;
  getData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get();
    print(widget.id);
    user = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: CircleAvatar(
                radius: 32,
                foregroundImage: CachedNetworkImageProvider(user!.url),
              ),
              title: Text(user!.username),
              trailing: Container(
                height: 30,
                alignment: Alignment.center,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: user!.followers.contains(widget.originalId)
                        ? Colors.white
                        : Colors.blue),
                child: user!.followers.contains(widget.originalId)
                    ? InkWell(
                        onTap: () async {
                          await PostMethods().doUnFollow(
                              currentUid: widget.originalId, uid: widget.id);
                        },
                        child: Text(
                          "Unfollow",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          await PostMethods().doFollow(
                              currentUid: widget.originalId, uid: user!.uid);
                        },
                        child: Text("Follow")),
              ),
            ),
          );
  }
}
