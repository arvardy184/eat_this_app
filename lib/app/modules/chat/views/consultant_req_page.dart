
import 'package:eat_this_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ConsultantRequestsPage extends GetView<ChatController> {
  const ConsultantRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation Requests'),
      ),
      body: Column(
        children: [

          // Request to become consultant card (only for type 'consultant')
          Obx(() => controller.typeUser.value == 'Consultant' && !controller.isConsultant.value
            ? Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Become a Consultant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Share your expertise and help others by becoming a consultant.',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await controller.fetchRequests();
                        },
                        child: const Text('Request to be Consultant'),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox()),

          // List of pending requests
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.users.isEmpty) {
                return const Center(child: Text('No pending requests'));
              }

              return RefreshIndicator(
                onRefresh: controller.fetchAcquaintances,
                child: ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final request = controller.users[index];
                    // Only show requests with status 0 (pending)
                    if (request.status != 0) return const SizedBox();
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: request.profilePicture != null
                              ? NetworkImage(request.profilePicture!)
                              : null,
                          child: request.profilePicture == null
                              ? Text(request.name?[0] ?? '')
                              : null,
                        ),
                        title: Text(request.name ?? 'Unknown'),
                        subtitle: Text(request.email ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle_outline),
                              color: Colors.green,
                              onPressed: () async {
                                await controller.handleAcquaintanceRequest(
                                  request.id!,
                                  1, // Accept
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              color: Colors.red,
                              onPressed: () async {
                                await controller.handleAcquaintanceRequest(
                                  request.id!,
                                  0, // Decline
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}