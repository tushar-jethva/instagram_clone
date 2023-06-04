import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/service/auth_methods.dart';

class UserProvider with ChangeNotifier {
  final AuthService authService = AuthService();
  UserModel _user = UserModel(
      username: "",
      bio: "",
      email: "",
      url: "",
      uid: "",
      followers: [],
      following: []);

  UserModel get user => _user;

  Future<void> refreshUser() async {
    UserModel user = await authService.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
