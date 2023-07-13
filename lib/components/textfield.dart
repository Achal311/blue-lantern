import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromRGBO(30, 144, 255, 1), width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            contentPadding: 
            const EdgeInsets.symmetric(vertical:10, horizontal:10),
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}