import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

void showSnackBar({required BuildContext context, required String data}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
}

pickImage() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery, imageQuality: 30);
  if (image != null) {
    return await image.readAsBytes();
  }
}

pickImagFromSources(ImageSource source) async {
  XFile? image =
      await ImagePicker().pickImage(source: source, imageQuality: 30);
  if (image != null) {
    return await image.readAsBytes();
  }
}

// pikeImage(ImageSource source) async {
//   ImagePicker piker = ImagePicker();
//   XFile? file = await piker.pickImage(source: source);
//   CroppedFile? file1 = await ImageCropper().cropImage(sourcePath: file!.path);
//   XFile? file2 = await FlutterImageCompress.compressAndGetFile(
//       File(file1!.path).absolute.path,
//       File(file1.path).absolute.path + "compress.jpg",
//       quality: 30);

//   if (file2 != null) {
//     return await file2.readAsBytes();
//   }
// }

loader() {
  return CircularProgressIndicator(
    color: Colors.white,
  );
}
