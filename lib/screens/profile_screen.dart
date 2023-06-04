import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/service/auth_methods.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
            onPressed: () async {
              await AuthService().signOut(context: context);
              Navigator.pushNamedAndRemoveUntil(
                  context, MyLoginScreen.routeName, (route) => false);
            },
            icon: Icon(Icons.logout)),
      ),
    );
  }
}
