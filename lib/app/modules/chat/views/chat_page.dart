import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading while initializing
      if (!controller.isInitialized.value || controller.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Show appropriate view based on consultant status
      return controller.isConsultant.value 
        ? _buildConsultantView(context)
        : _buildUserView(context);
    });
  }

  // View for Consultant
  Widget _buildConsultantView(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Consultation'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Clients'),
              Tab(text: 'Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Acquaintances Tab (Accepted Clients)
            _buildAcquaintancesTab(),
            // Requests Tab
            _buildRequestsTab(),
          ],
        ),
      ),
    );
  }
// Updated acquaintances tab for accepted clients
  Widget _buildAcquaintancesTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

   if (controller.acquaintances.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No active clients yet'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.fetchAcquaintances,
                child: const Text('Refresh'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchAcquaintances,
        child: ListView.builder(
          itemCount: controller.acquaintances.length,
          itemBuilder: (context, index) {
            final client = controller.acquaintances[index];
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
              onTap: () => Get.toNamed('/chat/room', arguments: client),
            );
          },
        ),
      );
    });
  }

  // Updated requests tab
  Widget _buildRequestsTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

    if (controller.requests.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No pending requests'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.fetchRequests,
                child: const Text('Refresh'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchRequests,  // Using dedicated method
        child: ListView.builder(
          itemCount: controller.requests.length,
          itemBuilder: (context, index) {
            final request = controller.requests[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      onPressed: () => controller.handleAcquaintanceRequest(
                        request.id!,
                        1, // Accept
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      color: Colors.red,
                      onPressed: () => controller.handleAcquaintanceRequest(
                        request.id!,
                        0, // Decline
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // View for regular User
  Widget _buildUserView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Consultants'),
        leading: IconButton(
          icon: const Icon(Icons.person_add_rounded),
          onPressed: () => Get.toNamed('/add-consultant'),
        ),
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
                return const Center(child: Text('No consultants found'));
              }

              return RefreshIndicator(
                onRefresh: controller.fetchAddedConsultants,
                child: ListView.builder(
                  itemCount: controller.addedConsultants.length,
                  itemBuilder: (context, index) {
                    final consultant = controller.addedConsultants[index];
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
                      onTap: () => Get.toNamed('/chat/room', arguments: consultant),
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