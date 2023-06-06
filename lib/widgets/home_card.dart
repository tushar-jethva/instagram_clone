// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/service/auth_methods.dart';
import 'package:instagram_clone/service/post_methods.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/Models/post_model.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:provider/provider.dart';

class MyHomeCard extends StatefulWidget {
  final PostModel snap;
  const MyHomeCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<MyHomeCard> createState() => _MyHomeCardState();
}

class _MyHomeCardState extends State<MyHomeCard> {
  bool isAnimating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllComments();
    getUserData();
  }

  int len = 0;

  void getAllComments() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap.postId)
        .collection('comments')
        .get();

    setState(() {
      len = snapshot.docs.length;
    });
  }

  UserModel? userdata;
  void getUserData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap.uid)
        .get();

    setState(() {
      userdata = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.snap.uid == FirebaseAuth.instance.currentUser!.uid
                      ? InkWell(
                          onTap: () {
                            PostMethods().deletePost(
                                postId: widget.snap.postId, context: context);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Delete a post",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : const Text(
                          "Can't Delete",
                          style: TextStyle(fontSize: 18),
                        )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                userdata != null
                    ? InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyProfileScreen.routeName,
                              arguments: {'user': userdata});
                        },
                        child: CircleAvatar(
                          radius: 22,
                          foregroundImage:
                              CachedNetworkImageProvider(widget.snap.url),
                        ),
                      )
                    : CircleAvatar(
                        radius: 22,
                        foregroundImage:
                            CachedNetworkImageProvider(widget.snap.url),
                      ),
                const Gap(15),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyProfileScreen.routeName,
                              arguments: {'user': userdata});
                        },
                        child: Text(widget.snap.username))),
                IconButton(
                    onPressed: () {
                      showDeleteDialog(context);
                    },
                    icon: Icon(Icons.more_vert_outlined)),
              ],
            ),
          ),
          const Gap(15),
          GestureDetector(
            onDoubleTap: () {
              PostMethods().likePost(
                  postId: widget.snap.postId,
                  uid: user.uid,
                  likes: widget.snap.likes);
              setState(() {
                isAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: size.height * 0.43,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(widget.snap.postUrl),
                          fit: BoxFit.contain)),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: isAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                    isAnimating: isAnimating,
                    duration: Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap.likes.contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await PostMethods().likePost(
                        postId: widget.snap.postId,
                        uid: user.uid,
                        likes: widget.snap.likes);
                  },
                  icon: widget.snap.likes.contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                  color: Colors.white,
                  iconSize: 28,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, MyCommentScreen.routeName,
                      arguments: {'post': widget.snap});
                },
                icon: Icon(Icons.message_outlined),
                color: Colors.white,
                iconSize: 25,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(FluentSystemIcons.ic_fluent_send_filled),
                color: Colors.white,
                iconSize: 25,
              ),
              Spacer(),
              widget.snap.bookMark
                      .contains(FirebaseAuth.instance.currentUser!.uid)
                  ? IconButton(
                      onPressed: () async {
                        await PostMethods().doUnBookMark(
                            postId: widget.snap.postId,
                            currId: FirebaseAuth.instance.currentUser!.uid);
                      },
                      icon: Icon(FluentSystemIcons.ic_fluent_bookmark_filled),
                      color: Colors.white,
                      iconSize: 28,
                    )
                  : IconButton(
                      onPressed: () async {
                        await PostMethods().doBookMark(
                            postId: widget.snap.postId,
                            currId: FirebaseAuth.instance.currentUser!.uid);
                      },
                      icon: Icon(FluentSystemIcons.ic_fluent_bookmark_regular),
                      color: Colors.white,
                      iconSize: 28,
                    ),
            ],
          ),
          Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.snap.likes.length} likes"),
                Gap(8),
                Row(
                  children: [
                    Text(widget.snap.username),
                    Gap(10),
                    Text(widget.snap.desc),
                  ],
                ),
                Gap(10),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, MyCommentScreen.routeName,
                        arguments: {'post': widget.snap});
                  },
                  child: Text(
                    "View all $len Comments...",
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                ),
                Gap(10),
                Text(DateFormat.yMMMd()
                    .format(widget.snap.datePublished.toDate())),
              ],
            ),
          )
        ],
      ),
    );
  }
}
