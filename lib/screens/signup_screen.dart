import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/widgets/custom_button.dart';
import 'package:instagram_clone/widgets/custom_textfield.dart';

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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
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
                Gap(size.height * 0.21),
                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  color: primaryColor,
                  height: 64,
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
                              Navigator.pushNamedAndRemoveUntil(context,
                                  MySignUpScreen.routeName, (route) => false);
                            }
                          },
                          text: "Sign Up"),
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
                        child: Text(
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
