import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Page"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text("Product Page"),
      ),
    );
  }
}
