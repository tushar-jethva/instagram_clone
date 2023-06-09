// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyCustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final bool isPass;
  const MyCustomTextField({
    Key? key,
    required this.controller,
    required this.text,
    this.isPass = false,
  }) : super(key: key);

  @override
  State<MyCustomTextField> createState() => _MyCustomTextFieldState();
}

class _MyCustomTextFieldState extends State<MyCustomTextField> {
  bool isShow = true;
  @override
  Widget build(BuildContext context) {
    return widget.isPass
        ? TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ${widget.text}';
              }
            },
            controller: widget.controller,
            obscureText: isShow,
            decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                labelText: widget.text,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                suffixIcon: IconButton(
                  icon: isShow
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      isShow = !isShow;
                    });
                  },
                )),
          )
        : TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ${widget.text}';
              }
            },
            controller: widget.controller,
            decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white),
              ),
              labelText: widget.text,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          );
  }
}
