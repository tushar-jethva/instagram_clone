import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/user_model.dart';
import 'package:instagram_clone/responsive/mobilescreen_layout.dart';
import 'package:instagram_clone/responsive/responsive_screen.dart';
import 'package:instagram_clone/responsive/webscreen_layout.dart';
import 'package:instagram_clone/service/storage_methods.dart';
import 'package:instagram_clone/utills/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection("users").doc(currentUser.uid).get();
    return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<String> signUp({
    required BuildContext context,
    required String username,
    required String bio,
    required String email,
    required String password,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      //make a user call in api
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //make a call to storage from where we want url of image that we will store in firestore
      String url = await StorageServices().uploadImagesInStorage(
          childName: "ProfilePics", file: file, isPost: false);

      UserModel userModel = UserModel(
          username: username,
          bio: bio,
          email: email,
          url: url,
          uid: cred.user!.uid,
          followers: [],
          following: []);

      //make a call to save username and etc. in firestore database
      await _firestore
          .collection("users")
          .doc(cred.user!.uid)
          .set(userModel.toMap());

      // ignore: use_build_context_synchronously
      showSnackBar(context: context, data: "Success");
      Navigator.pushNamedAndRemoveUntil(
          context, MyResponsiveScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        showSnackBar(context: context, data: "Please enter valid email!");
      } else if (err.code == "weak-password") {
        showSnackBar(context: context, data: "Your password is weak!");
      }
    } catch (err) {
      showSnackBar(context: context, data: err.toString());
    }
    return res;
  }

  Future<String> login(
      {required BuildContext context,
      required String email,
      required String password}) async {
    String res = "some error occured";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      showSnackBar(context: context, data: "You are logged In!");
      Navigator.pushNamedAndRemoveUntil(
          context, MyResponsiveScreen.routeName, (route) => false);
      res = "success";
    } catch (err) {
      showSnackBar(context: context, data: err.toString());
    }
    return res;
  }

  signOut({required BuildContext context}) async {
    try {
      await _auth.signOut();
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
  }
}
