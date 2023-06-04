import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/Models/post_model.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:instagram_clone/utills/constants.dart';
import 'package:instagram_clone/widgets/home_card.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: Colors.white,
          height: 40,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished', descending: true)
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
                itemBuilder: (context, index) {
                  return MyHomeCard(
                    snap: PostModel.fromMap(snapshot.data!.docs[index].data()),
                  );
                });
          }),
    );
  }
}
