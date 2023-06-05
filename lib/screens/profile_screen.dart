// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:instagram_clone/Models/post_model.dart';
import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/screens/followers_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/view_post_screen.dart';
import 'package:instagram_clone/service/auth_methods.dart';
import 'package:instagram_clone/service/post_methods.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:instagram_clone/widgets/profile_col.dart';
import 'package:instagram_clone/widgets/profile_container.dart';

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
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .snapshots()
        .listen(
          (event) => getLengths(),
        );
    getPost();
  }

  int len = 0;
  getPost() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.user.uid)
        .get();
    setState(() {
      len = snapshot.docs.length;
    });
  }

  int followersLength = 0;
  int followingLength = 0;
  UserModel newUser = UserModel(
      username: '',
      bio: '',
      email: '',
      url: '',
      uid: '',
      followers: [],
      following: []);

  getLengths() async {
    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();
    followersLength = snap.data()!['followers'].length;
    followingLength = snap.data()!['following'].length;
    newUser = UserModel.fromMap(snap.data() as Map<String, dynamic>);
    setState(() {});
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
                                  text1: len!.toString(),
                                  text2: "Posts",
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MyFollowersScreen.routeName,
                                        arguments: {
                                          'uid': widget.user.uid,
                                          'isFollowers': true
                                        });
                                  },
                                  child: MyProfileColumn(
                                    text1: followersLength!.toString(),
                                    text2: "Followers",
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MyFollowersScreen.routeName,
                                        arguments: {
                                          'uid': widget.user.uid,
                                          'isFollowers': false
                                        });
                                  },
                                  child: MyProfileColumn(
                                    text1: followingLength!.toString(),
                                    text2: "Following",
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              child: newUser.uid ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? MyProfileContainer(
                                      text: "Sign Out",
                                      onTap: () async {
                                        await AuthService()
                                            .signOut(context: context);
                                      },
                                      isCurrUser: true,
                                    )
                                  : newUser.followers.contains(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      ? MyProfileContainer(
                                          text: "Unfollow",
                                          isCurrUser: false,
                                          isFollowed: true,
                                          onTap: () async {
                                            await PostMethods().doUnFollow(
                                                currentUid: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                uid: widget.user.uid);
                                          },
                                        )
                                      : MyProfileContainer(
                                          text: "Follow",
                                          isCurrUser: false,
                                          isFollowed: false,
                                          onTap: () async {
                                            await PostMethods().doFollow(
                                                currentUid: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                uid: widget.user.uid);
                                          },
                                        ),
                            ),
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
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: widget.user.uid)
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.data == null) {
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
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MyPostViewScreen.routeName,
                                  arguments: {
                                    "uid": snapshot.data!.docs[index]['uid'],
                                    "initIndex": index
                                  });
                            },
                            child: Container(
                              child: Image(
                                image: CachedNetworkImageProvider(snapshot
                                    .data!.docs[index]
                                    .data()['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                  );
                })
          ],
        ));
  }
}
