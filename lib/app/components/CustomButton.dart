import 'package:eat_this_app/app/components/Loading.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    required this.isPrimary,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: isLoading
          ? Loading(color: isPrimary ? Colors.white : Colors.blue)
          : Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: isPrimary ? Colors.white : Colors.blue,
        backgroundColor: isPrimary ? Colors.blue : Colors.white,
        side: BorderSide(color: Colors.blue),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
