import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.hint,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.white,
        filled: true, // This line makes the background color visible
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
