import 'package:flutter/material.dart';

class PharmacyPage extends StatelessWidget {
  const PharmacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pharmacy"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text("Pharmacy"),
      ),
    );
  }
}
