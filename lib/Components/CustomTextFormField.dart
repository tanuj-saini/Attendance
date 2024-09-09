import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon iconButton;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey[200],
      ),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: iconButton,
          prefixIconColor: Colors.grey,
          fillColor: Colors.black,
          hintText: hintText,
          hintStyle: TextStyle(color: const Color.fromARGB(99, 0, 0, 0)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
