// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/service/auth_methods.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:instagram_clone/widgets/profile_col.dart';

class MyProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  final UserModel user;
  const MyProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPost();
  }

  int? len;
  getPost() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.user.uid)
        .get();
    setState(() {
      len = snapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(widget.user.username),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        foregroundImage:
                            CachedNetworkImageProvider(widget.user.url),
                        radius: 43,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MyProfileColumn(
                                  text1: len == null ? '0' : len!.toString(),
                                  text2: "Posts",
                                ),
                                MyProfileColumn(
                                  text1:
                                      widget.user.followers.length.toString(),
                                  text2: "Followers",
                                ),
                                MyProfileColumn(
                                  text1:
                                      widget.user.following.length.toString(),
                                  text2: "Following",
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                alignment: Alignment.center,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: InkWell(
                                  onTap: () {
                                    AuthService().signOut(context: context);
                                  },
                                  child: widget.user.uid ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Text(
                                          'Sign Out',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )
                                      : widget.user.followers.contains(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          ? Text('unfollow')
                                          : Text("Follow"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(10),
                  Text(
                    widget.user.username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Gap(1),
                  Text(
                    widget.user.bio,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  )
                ],
              ),
            ),
            Gap(50),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: widget.user.uid)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Flexible(
                    child: GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return Container(
                            child: Image(
                              image: CachedNetworkImageProvider(
                                  snapshot.data!.docs[index].data()['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                  );
                })
          ],
        ));
  }
}
