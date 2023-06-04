import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/add_post.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:instagram_clone/utills/constants.dart';
import 'package:instagram_clone/widgets/custom_button.dart';

class MyUploadScreen extends StatefulWidget {
  const MyUploadScreen({super.key});

  @override
  State<MyUploadScreen> createState() => _MyUploadScreenState();
}

Uint8List? image;

class _MyUploadScreenState extends State<MyUploadScreen> {
  void showDialogNow() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Upload a Post",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            actions: [
              MyCustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  widget: Text("Cancel"))
            ],
            content: SizedBox(
              height: 122,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      image = await pickImagFromSources(ImageSource.camera);
                      setState(() {});
                      Navigator.pop(context);
                      Navigator.pushNamed(context, MyAddPostScreen.routeName,
                          arguments: {"image": image});
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Take a photo",
                          style: TextStyle(color: mobileBackgroundColor),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      image = await pickImagFromSources(ImageSource.gallery);
                      setState(() {});
                      Navigator.pop(context);
                      Navigator.pushNamed(context, MyAddPostScreen.routeName,
                          arguments: {"image": image});
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Choose from Gallery",
                          style: TextStyle(color: mobileBackgroundColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
            showDialogNow();
          },
          icon: Icon(Icons.upload),
        ),
      ),
    );
  }
}
