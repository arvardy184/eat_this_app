
import 'package:eat_this_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
class AcquaintancesPage extends GetView<ChatController> {
  const AcquaintancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Clients'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Filter only accepted clients (status == 1)
        final acceptedClients = controller.users.where((user) => user.status == 1).toList();

        if (acceptedClients.isEmpty) {
          return const Center(child: Text('No clients yet'));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAcquaintances,
          child: ListView.builder(
            itemCount: acceptedClients.length,
            itemBuilder: (context, index) {
              final client = acceptedClients[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: client.profilePicture != null
                      ? NetworkImage(client.profilePicture!)
                      : null,
                  child: client.profilePicture == null
                      ? Text(client.name?[0] ?? '')
                      : null,
                ),
                title: Text(client.name ?? 'Unknown'),
                subtitle: Text(client.email ?? ''),
                trailing: const Icon(Icons.chat_bubble_outline),
                onTap: () {
                  Get.toNamed('/chat/room', arguments: client);
                },
              );
            },
          ),
        );
      }),
    );
  }
}