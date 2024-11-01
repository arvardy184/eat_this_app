import 'package:eat_this_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:eat_this_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListConsultantPage extends GetView<ChatController> {
  const ListConsultantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Consultant'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search consultants...',
                prefixIcon: const Icon(Icons.search),
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
                return const Center(child: CircularProgressIndicator());
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
                    trailing: const Icon(Icons.chat_bubble_outline),
                    onTap: () {
                      // Custom dialog to show consultant details and add button
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(consultant.name!),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Specialization: ${consultant.specialization ?? 'General Consultant'}'),
                              const SizedBox(height: 16),
                              const Text('No description available'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Call the function to add the consultant
                                print("berapa id: ${consultant.id}");
                                await controller.addConsultant(consultant.id!);
                                Get.back();
                               
                              },
                              child: const Text('Add Consultant'),
                            ),
                          ],
                        ),
                      );
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
