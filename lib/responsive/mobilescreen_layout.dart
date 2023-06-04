import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/screens/upload_screen.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:provider/provider.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

class MyMobileScreenLayout extends StatefulWidget {
  const MyMobileScreenLayout({super.key});

  @override
  State<MyMobileScreenLayout> createState() => _MyMobileScreenLayoutState();
}

class _MyMobileScreenLayoutState extends State<MyMobileScreenLayout> {
  int currentIndex = 0;

  void onTap(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  List<Widget> screens = [
    MyHomeScreen(),
    MySearchScreen(),
    MyUploadScreen(),
    Text("Heart Screen"),
    MyProfileScreen(

    )
  ];

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      body: Center(child: screens[currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: onTap,
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          elevation: 0,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: mobileBackgroundColor,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_search_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_search_filled),
                label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_add_circle_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_add_circle_filled),
                label: 'Add'),
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_heart_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_heart_filled),
                label: 'Favourite'),
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_person_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_person_filled),
                label: 'Profile'),
          ]),
    );
  }
}
