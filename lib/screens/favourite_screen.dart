// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/post_model.dart';

import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:instagram_clone/widgets/home_card.dart';

class MyFavouriteScreen extends StatefulWidget {
  static const routeName = '/favourite';

  const MyFavouriteScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyFavouriteScreen> createState() => _MyFavouriteScreenState();
}

class _MyFavouriteScreenState extends State<MyFavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Favourites'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('bookMark',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
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

          if (snapshot.data!.docs.length == 0) {
            return Center(
              child: Text(
                "Please do bookMarks!",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                return MyHomeCard(
                    snap: PostModel.fromMap(snapshot.data!.docs[index].data()));
              }));
        },
      ),
    );
  }
}
