import 'package:flutter/material.dart';

class RecommendationItem extends StatelessWidget {
  final String name;
  final String image;

  const RecommendationItem(
      {super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Image.asset(image, width: 60, height: 60,
              errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 60,
              height: 60,
              color: Colors.grey,
              child: const Icon(Icons.broken_image, color: Colors.white),
            );
          }),
          const SizedBox(height: 4),
          Text(name,
              textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}