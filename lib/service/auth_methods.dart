import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/service/storage_methods.dart';
import 'package:instagram_clone/utills/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

      //make a call to save username and etc. in firestore database
      await _firestore.collection("users").doc(cred.user!.uid).set({
        "username": username,
        "bio": bio,
        "email": email,
        "uid": cred.user!.uid,
        "followers": [],
        "following": [],
        "url": url
      });

      // ignore: use_build_context_synchronously
      showSnackBar(context: context, data: "Success");
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

      res = "success";
    } catch (err) {
      showSnackBar(context: context, data: err.toString());
    }
    return res;
  }
}
