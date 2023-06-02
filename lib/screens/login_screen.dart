import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:instagram_clone/utills/constants.dart';
import 'package:instagram_clone/widgets/custom_button.dart';
import 'package:instagram_clone/widgets/custom_textfield.dart';
import 'package:gap/gap.dart';

class MyLoginScreen extends StatefulWidget {
  static const routeName = "/login";
  const MyLoginScreen({super.key});

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  final _loginKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
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
                Gap(size.height * 0.15),
                const Gap(150),
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
                          controller: _usernameController, text: "Email"),
                      const Gap(20),
                      MyCustomTextField(
                        controller: _passwordController,
                        text: "Password",
                        isPass: true,
                      ),
                      const Gap(20),
                      MyCustomButton(
                          onPressed: () {
                            if (_loginKey.currentState!.validate()) {}
                          },
                          text: "Login"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Don't have an account ?"),
                      Gap(10),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              MySignUpScreen.routeName, (route) => false);
                        },
                        child: Text(
                          "SignUp",
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
