import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MySignUpScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MySignUpScreen(), settings: routeSettings);

    case MyLoginScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MyLoginScreen(), settings: routeSettings);

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(child: Text("Page not found")),
        ),
      );
  }
}
