// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utills/colors.dart';

import 'package:instagram_clone/widgets/followers_card.dart';

class MyFollowersScreen extends StatefulWidget {
  static const routeName = '/followers';
  final String uid;
  final bool isFollowers;
  const MyFollowersScreen({
    Key? key,
    required this.uid,
    required this.isFollowers,
  }) : super(key: key);

  @override
  State<MyFollowersScreen> createState() => _MyFollowersScreenState();
}

class _MyFollowersScreenState extends State<MyFollowersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: widget.isFollowers ? Text('Followers') : Text('Followings'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }
            return widget.isFollowers
                ? ListView.builder(
                    itemCount: snapshot.data!.data()!['followers'].length,
                    itemBuilder: (context, index) {
                      return MyFollowersCard(
                          originalId: widget.uid,
                          id: snapshot.data!.data()!['followers'][index]);
                    })
                : ListView.builder(
                    itemCount: snapshot.data!.data()!['following'].length,
                    itemBuilder: (context, index) {
                      return MyFollowersCard(
                          originalId: widget.uid,
                          id: snapshot.data!.data()!['following'][index]);
                    });
          }),
    );
  }
}
