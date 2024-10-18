import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double size;
  final Color color;

  const Loading({
    Key? key,
    this.size = 24.0,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: 2.0,
      ),
    );
  }
}
