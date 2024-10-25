// lib/app/modules/chat/views/chat_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatPage extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultants'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search consultants...',
                prefixIcon: const  Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: controller.onSearchChanged,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.consultants.isEmpty) {
                return Center(child: Text('No consultants found'));
              }

              return ListView.builder(
                itemCount: controller.consultants.length,
                itemBuilder: (context, index) {
                  final consultant = controller.consultants[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: consultant.profilePicture != null
                          ? NetworkImage(consultant.profilePicture!)
                          : null,
                      child: consultant.profilePicture == null
                          ? Text(consultant.name![0])
                          : null,
                    ),
                    title: Text(consultant.name!),
                    subtitle: Text(consultant.specialization ?? 'General Consultant'),
                    trailing: Icon(Icons.chat_bubble_outline),
                    onTap: () {
                      // Navigate to chat room
                      Get.toNamed('/chat/room', arguments: consultant);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}