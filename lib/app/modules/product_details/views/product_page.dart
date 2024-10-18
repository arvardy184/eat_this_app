import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> productData;

  ProductDetails({required this.productData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productData['product_name'] ?? 'Unknown Product',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Brand: ${productData['brands'] ?? 'Unknown'}'),
          SizedBox(height: 8),
          Text('Ingredients: ${productData['ingredients_text'] ?? 'Not available'}'),
          SizedBox(height: 8),
          Text('Allergens: ${productData['allergens'] ?? 'None listed'}'),
          // Add more details as needed
        ],
      ),
    );
  }
}