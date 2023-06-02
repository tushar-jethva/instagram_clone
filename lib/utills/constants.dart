import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String data}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
}
