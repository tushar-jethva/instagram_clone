import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/screens/favourite_screen.dart';
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
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                border: InputBorder.none, labelText: "Search a User"),
            onSubmitted: (value) {
              setState(() {
                isShowUser = true;
              });
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
                                context, MyFavouriteScreen.routeName,
                                arguments: {
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
            : Text("HI"));
  }
}
