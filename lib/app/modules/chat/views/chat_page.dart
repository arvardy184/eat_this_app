import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text("Chat"),
      ),
    );
  }
}
