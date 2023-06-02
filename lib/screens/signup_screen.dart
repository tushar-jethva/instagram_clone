import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/service/auth_methods.dart';
import 'package:instagram_clone/utills/constants.dart';
import 'package:instagram_clone/widgets/custom_button.dart';
import 'package:instagram_clone/widgets/custom_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utills/colors.dart';

class MySignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  const MySignUpScreen({super.key});

  @override
  State<MySignUpScreen> createState() => _MySignUpScreenState();
}

class _MySignUpScreenState extends State<MySignUpScreen> {
  final _loginKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoad = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _bioController.dispose();
  }

  Uint8List? image;

  void pickImage1() async {
    image = await pickImage();
    setState(() {});
  }

  String? res;
  signUpUser() async {
    setState(() {
      isLoad = true;
    });
    res = await authService.signUp(
        context: context,
        username: _usernameController.text,
        bio: _bioController.text,
        email: _emailController.text,
        password: _passwordController.text,
        file: image!);
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(size.height * 0.03),
                const Gap(30),
                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  color: primaryColor,
                  height: 64,
                ),
                const Gap(55),
                Stack(
                  children: [
                    image == null
                        ? const CircleAvatar(
                            radius: 64,
                            foregroundImage: AssetImage('assets/man.png'),
                          )
                        : CircleAvatar(
                            radius: 64, foregroundImage: MemoryImage(image!)),
                    Positioned(
                        right: 4,
                        bottom: -7,
                        child: IconButton(
                            onPressed: () {
                              pickImage1();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ))),
                  ],
                ),
                const Gap(30),
                Form(
                  key: _loginKey,
                  child: Column(
                    children: [
                      MyCustomTextField(
                          controller: _usernameController, text: "Username"),
                      const Gap(20),
                      MyCustomTextField(
                          controller: _bioController, text: "Bio"),
                      const Gap(20),
                      MyCustomTextField(
                          controller: _emailController, text: "Email"),
                      const Gap(20),
                      MyCustomTextField(
                        controller: _passwordController,
                        text: "Password",
                        isPass: true,
                      ),
                      const Gap(20),
                      MyCustomButton(
                        onPressed: () {
                          if (_loginKey.currentState!.validate()) {
                            if (image == null) {
                              showSnackBar(
                                  context: context,
                                  data: "Please choose image!");
                            } else {
                              signUpUser();
                            }
                          }
                        },
                        widget: isLoad ? loader() : Text("Sign Up"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Already have an account ?"),
                      Gap(10),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              MyLoginScreen.routeName, (route) => false);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
