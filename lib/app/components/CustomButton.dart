import 'package:eat_this_app/app/components/Loading.dart';
import 'package:eat_this_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback? onPressed;
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
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isPrimary ? Colors.white : CIETTheme.primary_color,
        backgroundColor: isPrimary ? CIETTheme.primary_color : Colors.white,
        side: BorderSide(color: CIETTheme.primary_color),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBackgroundColor: isPrimary ? CIETTheme.primary_color.withOpacity(0.7) : Colors.grey[300],
        disabledForegroundColor: isPrimary ? Colors.white70 : Colors.grey,
      ),
      child: isLoading
          ? Loading(color: isPrimary ? Colors.white : CIETTheme.primary_color)
          : Text(text),
    );
  }
}