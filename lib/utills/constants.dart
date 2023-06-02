import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String data}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
}

pickImage() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery, imageQuality: 20);
  if (image != null) {
    return await image.readAsBytes();
  }
}

loader() {
  return CircularProgressIndicator(
    color: Colors.white,
  );
}
