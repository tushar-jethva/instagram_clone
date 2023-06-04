// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';

import 'package:instagram_clone/utills/dimension.dart';
import 'package:provider/provider.dart';

class MyResponsiveScreen extends StatefulWidget {
  static const routeName = "/responsive";
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const MyResponsiveScreen({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<MyResponsiveScreen> createState() => _MyResponsiveScreenState();
}

class _MyResponsiveScreenState extends State<MyResponsiveScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    UserProvider user = Provider.of(context, listen: false);
    await user.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        //show web screen
        return widget.webScreenLayout;
      } else {
        //mobile screen
        return widget.mobileScreenLayout;
      }
    });
  }
}
