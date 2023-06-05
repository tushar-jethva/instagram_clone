// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone/Models/post_model.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:instagram_clone/widgets/home_card.dart';

class MyPostViewScreen extends StatefulWidget {
  static const routeName = '/viewpost';
  final String uid;
  final int initIndex;
  const MyPostViewScreen({
    Key? key,
    required this.uid,
    required this.initIndex,
  }) : super(key: key);

  @override
  State<MyPostViewScreen> createState() => _MyPostViewScreenState();
}

class _MyPostViewScreenState extends State<MyPostViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        backgroundColor: mobileBackgroundColor,
        title: Text('Posts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: widget.uid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              return MyHomeCard(
                  snap: PostModel.fromMap(snapshot.data!.docs[index].data()));
            }),
          );
        },
      ),
    );
  }
}
