import 'package:eat_this_app/app/data/models/consultant2_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../controllers/subscription_controller.dart';
class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isInitialized.value || controller.isLoading.value) {
        return _buildLoadingView();
      }

      if (controller.isConsultant.value && controller.typeUser.value == 'Consultant') {
        return _buildConsultantView(context);
      } else if (controller.typeUser.value == 'Pharmacy') {
        return _buildApotekView(context);
      }

      if (!controller.canAccessChat()) {
        return _buildSubscriptionView(context, Get.find());
      }

      return _buildUserView(context);
    });
  }

  Widget _buildLoadingView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Initializing Chat...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expert Consultation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            onPressed: () => Get.toNamed('/add-consultant'),
            tooltip: 'Add New Consultant',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildConsultantsList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search consultants...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
                
      
            },
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: controller.onSearchChanged,
      ),
    );
  }

  Widget _buildConsultantsList() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingConsultants();
        }

        if (controller.addedConsultants.isEmpty) {
          return _buildEmptyConsultants();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAddedConsultants,
          child: ListView.builder(
            itemCount: controller.addedConsultants.length,
            itemBuilder: (context, index) {
              final consultant = controller.addedConsultants[index];
              return _buildConsultantCard(consultant);
            },
          ),
        );
      }),
    );
  }

  Widget _buildLoadingConsultants() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading consultants...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyConsultants() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Consultants Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a consultant to start chatting',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed('/add-consultant'),
            icon: const Icon(Icons.add),
            label: const Text('Add Consultant'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultantCard(ConsultantData consultant) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => Get.toNamed('/chat/room', arguments: consultant),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildConsultantAvatar(consultant),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          consultant.name ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '2m ago', // Add timestamp logic
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      consultant.specialization ?? 'Nutrition Expert',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Online',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        if (consultant.lastMessage != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsultantAvatar(ConsultantData consultant) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: consultant.profilePicture != null
              ? NetworkImage(consultant.profilePicture!)
              : null,
          child: consultant.profilePicture == null
              ? Text(
                  consultant.name?[0] ?? '',
                  style: const TextStyle(fontSize: 20),
                )
              : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              Icons.verified,
              size: 16,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
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
        onRefresh: controller.fetchRequests,
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
                        2, // Decline
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

  // // View for regular User
  // Widget _buildUserView(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('My Consultants'),
  //       leading: IconButton(
  //         icon: const Icon(Icons.person_add_rounded),
  //         onPressed: () => Get.toNamed('/add-consultant'),
  //       ),
  //     ),
  //     body: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: TextField(
  //             decoration: InputDecoration(
  //               hintText: 'Search consultants...',
  //               prefixIcon: const Icon(Icons.search),
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //             ),
  //             onChanged: controller.onSearchChanged,
  //           ),
  //         ),
  //         Expanded(
  //           child: Obx(() {
  //             if (controller.isLoading.value) {
  //               return const Center(child: CircularProgressIndicator());
  //             }

  //             if (controller.consultants.isEmpty) {
  //               return const Center(child: Text('No consultants found'));
  //             }

  //             return RefreshIndicator(
  //               onRefresh: controller.fetchAddedConsultants,
  //               child: ListView.builder(
  //                 itemCount: controller.addedConsultants.length,
  //                 itemBuilder: (context, index) {
  //                   final consultant = controller.addedConsultants[index];
  //                   return ListTile(
  //                     leading: CircleAvatar(
  //                       backgroundImage: consultant.profilePicture != null
  //                           ? NetworkImage(consultant.profilePicture!)
  //                           : null,
  //                       child: consultant.profilePicture == null
  //                           ? Text(consultant.name?[0] ?? '')
  //                           : null,
  //                     ),
  //                     title: Text(consultant.name ?? 'Unknown'),
  //                     subtitle: Text(
  //                         consultant.lastMessage ?? 'No messages yet',style: TextStyle(
  //                           color: Colors.grey[500],
  //                           fontSize: 14
  //                         ),),
  //                     trailing: const Icon(Icons.chat_bubble_outline),
  //                     onTap: () =>
  //                         Get.toNamed('/chat/room', arguments: consultant),
  //                   );
  //                 },
  //               ),
  //             );
  //           }),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildApotekView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation'),
        // leading: IconButton(
        //   icon: const Icon(Icons.person_add_rounded),
        //   onPressed: () => Get.toNamed('/add-consultant'),
        // ),
      ),
      body: Center(
        child: Text('Chat Tidak Tersedia Untuk Apotek'),
      ),
    );
  }

  

 Widget _buildSubscriptionView(BuildContext context, SubscriptionController subscriptionController) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Plan',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the best plan for your needs',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            
            // Package Comparison Cards
            Obx(() {
              if (subscriptionController.packages.isEmpty) {
                return Center(
                  child: Text('No packages available'),
                );
              }

              if (subscriptionController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

               if (subscriptionController.packages.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Text('No packages available'),
                    ElevatedButton(
                      onPressed: subscriptionController.loadPackages,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

              return Column(
                children: subscriptionController.packages.map((package) {
                  final isPremium = package.name?.toLowerCase() == 'premium';
                  return Card(
                    elevation: isPremium ? 4 : 1,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: isPremium 
                        ? BorderSide(color: Colors.blue, width: 2)
                        : BorderSide.none,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Package Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    package.name ?? '',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isPremium ? Colors.blue : Colors.grey[800],
                                    ),
                                  ),
                                  if (isPremium)
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8, 
                                        vertical: 2
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'RECOMMENDED',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    package.price == 0 
                                      ? 'FREE' 
                                      : 'Rp ${package.price?.toStringAsFixed(0) ?? '0'}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isPremium ? Colors.blue : Colors.grey[800],
                                    ),
                                  ),
                         
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Package Features
                          _buildPackageFeature(
                            'Product Scans',
                            package.maxScan == 0 
                              ? 'No scans' 
                              : '${package.maxScan} scans',
                            isPremium,
                          ),
                          _buildPackageFeature(
                            'Expert Consultations',
                            package.maxConsultant == 0 
                              ? 'No consultations' 
                              : '${package.maxConsultant} consultants',
                            isPremium,
                          ),
                          _buildPackageFeature(
                            'Priority Support',
                            isPremium ? 'Yes' : 'No',
                            isPremium,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Action Button
                          if (isPremium) 
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => subscriptionController.showUpgradeDialog(),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Upgrade Now',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            
            const SizedBox(height: 32),
            
            // Additional Information
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why Upgrade?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    icon: Icons.verified_user,
                    title: 'Expert Guidance',
                    description: 'Get advice from certified nutritionists',
                  ),
                  _buildBenefitItem(
                    icon: Icons.speed,
                    title: 'Unlimited Access',
                    description: 'Scan more products and get more consultations',
                  ),
                  _buildBenefitItem(
                    icon: Icons.support_agent,
                    title: 'Priority Support',
                    description: 'Get faster response from our team',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue[700]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageFeature(String feature, String value, bool isPremium) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: isPremium ? Colors.blue : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPremium ? Colors.blue : Colors.grey[800],
            ),
          ),
        ],
      ),
    );

    
  }

  
}
