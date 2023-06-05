import 'package:flutter/material.dart';
import 'package:instagram_clone/responsive/mobilescreen_layout.dart';
import 'package:instagram_clone/responsive/responsive_screen.dart';
import 'package:instagram_clone/responsive/webscreen_layout.dart';
import 'package:instagram_clone/screens/add_post.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/screens/favourite_screen.dart';
import 'package:instagram_clone/screens/followers_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/screens/view_post_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MySignUpScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MySignUpScreen(), settings: routeSettings);

    case MyLoginScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MyLoginScreen(), settings: routeSettings);

    case MyResponsiveScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MyResponsiveScreen(
              webScreenLayout: MyWebScreenLayout(),
              mobileScreenLayout: MyMobileScreenLayout()));

    case MyAddPostScreen.routeName:
      Map<String, dynamic> data =
          routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => MyAddPostScreen(
          image: data['image'],
        ),
        settings: routeSettings,
      );

    case MyCommentScreen.routeName:
      Map<String, dynamic> map =
          routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) {
            return MyCommentScreen(
              post: map['post'],
            );
          },
          settings: routeSettings);

    case MyFavouriteScreen.routeName:
      Map<String, dynamic> map =
          routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) {
            return MyFavouriteScreen(
              user: map['user'],
            );
          },
          settings: routeSettings);

    case MyProfileScreen.routeName:
      Map<String, dynamic> map =
          routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) {
            return MyProfileScreen(
              user: map['user'],
            );
          },
          settings: routeSettings);

    case MyPostViewScreen.routeName:
      Map<String, dynamic> map =
          routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) {
            return MyPostViewScreen(
                uid: map['uid'], initIndex: map['initIndex']);
          },
          settings: routeSettings);

      case MyFollowersScreen.routeName:
      Map<String, dynamic> map =
          routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) {
            return MyFollowersScreen(
                uid: map['uid'],isFollowers: map['isFollowers'],);
          },
          settings: routeSettings);

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(child: Text("Page not found")),
        ),
      );
  }
}
