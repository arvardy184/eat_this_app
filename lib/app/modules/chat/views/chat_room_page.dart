// lib/app/modules/chat/views/chat_room_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eat_this_app/app/data/models/consultant_model.dart';
import 'package:eat_this_app/app/themes/app_theme.dart';
import '../controllers/chat_controller.dart';

class ChatRoomPage extends GetView<ChatController> {
  const ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final consultant = Get.arguments as ConsultantData;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: consultant.profilePicture != null
                  ? NetworkImage(consultant.profilePicture!)
                  : null,
              child: consultant.profilePicture == null
                  ? Text(consultant.name![0])
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(consultant.name!),
                Text(
                  consultant.specialization ?? 'General Consultant',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options menu
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.block),
                      title: const Text('Block Consultant'),
                      onTap: () {
                        // Implement block functionality
                        Get.back();
                        // Show confirmation dialog
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Block Consultant'),
                            content: Text('Are you sure you want to block ${consultant.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Implement block logic
                                  Get.back();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Block'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.report),
                      title: const Text('Report Issue'),
                      onTap: () {
                        // Implement report functionality
                        Get.back();
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Report Issue'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('What issue would you like to report?'),
                                const SizedBox(height: 16),
                                TextField(
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    hintText: 'Describe the issue...',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Implement report logic
                                  Get.back();
                                  Get.snackbar(
                                    'Report Submitted',
                                    'Thank you for your report. We will review it shortly.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: 0, // Replace with actual message count
              itemBuilder: (context, index) {
                // Replace with actual message widget
                return const SizedBox();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // Implement file attachment
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo),
                            title: const Text('Photo'),
                            onTap: () {
                              // Implement photo picker
                              Get.back();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.file_present),
                            title: const Text('Document'),
                            onTap: () {
                              // Implement document picker
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: CIETTheme.primary_color,
                  onPressed: () {
                    // Implement send message
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}