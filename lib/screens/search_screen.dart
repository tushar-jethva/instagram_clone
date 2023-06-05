import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/screens/favourite_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
// ignore: depend_on_referenced_packages

class MySearchScreen extends StatefulWidget {
  const MySearchScreen({super.key});

  @override
  State<MySearchScreen> createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<MySearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  bool isShowUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                border: InputBorder.none, labelText: "Search a User"),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isShowUser = true;
                });
              } else {
                setState(() {
                  isShowUser = false;
                });
              }
            },
          ),
        ),
        body: isShowUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: _searchController.text)
                    .get(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  }

                  return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MyProfileScreen.routeName, arguments: {
                              'user': UserModel.fromMap(
                                  (snapshot.data! as dynamic)
                                      .docs[index]
                                      .data())
                            });
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              foregroundImage: CachedNetworkImageProvider(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['url']),
                            ),
                            title: Text((snapshot.data! as dynamic)
                                .docs[index]
                                .data()['username']),
                          ),
                        );
                      }));
                }))
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!.docs[index]['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    staggeredTileBuilder: (index) => StaggeredTile.count(
                        (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  );
                },
              ));
  }
}
