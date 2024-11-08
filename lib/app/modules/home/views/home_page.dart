import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/modules/chat/controllers/subscription_controller.dart';
import 'package:eat_this_app/app/modules/home/controllers/home_controller.dart';
import 'package:eat_this_app/app/modules/pharmacy/controllers/pharmacy_controller.dart';
import 'package:eat_this_app/app/themes/app_theme.dart';
import 'package:eat_this_app/services/package_service.dart';
import 'package:eat_this_app/widgets/home/custom_app_bar.dart';
import 'package:eat_this_app/widgets/home/pharmacy_section.dart';
import 'package:eat_this_app/widgets/home/product_history_card.dart';
import 'package:eat_this_app/widgets/product/recommendation_widget.dart';
import 'package:eat_this_app/widgets/subscription/subscription_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final SubscriptionController subscriptionController = Get.put(
      SubscriptionController(Get.find<PackageService>(),
          packageService: PackageService(ApiProvider())));
  final PharmacyController pharmacyController = Get.put(PharmacyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          subscriptionController.refreshData();
          return controller.refreshData();
        },
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildWelcomeCard(),
                  _buildQuickActions(),
                  _buildSubscriptionStatus(),
                  _buildRecentScans(),
                  _buildStatistics(),
                  _buildRecommendations(),
                  _buildNearbyPharmacies(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: CIETTheme.primary_color,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [CIETTheme.primary_color, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Obx(() => Text(
              'Hi, ${controller.userData.value?.name ?? 'User'}! 👋',
              style: const TextStyle(fontSize: 20),
            )),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
      ),
      actions: [
        Obx(() => GestureDetector(
              onTap: () => Get.toNamed('/profile'),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  backgroundImage: controller.userData.value?.profilePicture !=
                          null
                      ? NetworkImage(controller.userData.value!.profilePicture!)
                      : null,
                  child: controller.userData.value?.profilePicture == null
                      ? const Icon(Icons.person)
                      : null,
                ),
              ),
            )),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start Your Healthy Journey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scan products to check their ingredients and find healthier alternatives',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.history,
            label: 'History',
            onTap: () => Get.toNamed('/all-scan'),
          ),
          _buildActionButton(
            icon: Icons.local_pharmacy,
            label: 'Pharmacies',
            onTap: () => Get.toNamed('/pharmacy'),
          ),
          _buildActionButton(
            icon: Icons.chat,
            label: 'Consult',
            onTap: () => Get.toNamed('/chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: CIETTheme.primary_color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionStatus() {
    return GetBuilder<SubscriptionController>(
      init: subscriptionController,
      builder: (controller) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Obx(() => Text(
                    controller.isPremium.value ? '✨ Premium' : 'Free Package',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: controller.isPremium.value
                          ? Colors.blue[900]
                          : Colors.grey[700],
                    ),
                  )),
              if (!controller.isPremium.value) ...[
                ElevatedButton(
                  onPressed: controller.showUpgradeDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CIETTheme.primary_color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Upgrade Now'),
                ),
              ],
            ]),
            const SizedBox(height: 16),
            _buildQuotaIndicator(
              'Daily Scans',
              controller.remainingScans.value,
              controller.recentScans.length,
              controller.isPremium.value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotaIndicator(
    String label,
    int max,
    int current,
    bool isPremium,
  ) {
    // Get total scans from controller
    final totalScans = controller.recentScans.length;
    print("is premiu m: $isPremium");
    // Calculate progress
    int progress;
    if (isPremium) {
      progress = 1;
      print("is premium progress: $progress");
    } else if (max <= 0) {
      print("max: $max");
      progress = 0;
    } else {
      progress = (totalScans / max).toInt();
      print("progress: $progress");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isPremium ? Icons.all_inclusive : Icons.timer,
              size: 20,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              label == 'Daily Scans'
                  ? isPremium
                      ? '${controller.recentScans.length}/$max'
                      : '${controller.recentScans.length}/$max'
                  : isPremium
                      ? '$max remaining'
                      : '$max remaining',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: (controller.recentScans.length < max || isPremium)
                    ? Colors.blue[900]
                    : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.toDouble(),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              isPremium
                  ? Colors.blue[900]!
                  : controller.recentScans.length >= max
                      ? Colors.red
                      : CIETTheme.primary_color,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentScans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Scans',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () => Get.toNamed('/all-scan'),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Obx(() {
            if (controller.isLoadingScans.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.recentScans.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'No recent scans',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: controller.recentScans.length,
              itemBuilder: (context, index) {
                final scan = controller.recentScans[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.network(
                            scan.imageUrl ?? '',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            scan.name ?? 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CIETTheme.primary_color, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.qr_code_scanner,
              value: '${controller.recentScans.length}',
              label: 'Total Scans',
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.trending_up,
              value:
                  '${controller.healthyPercentage.value.toStringAsFixed(1)}%',
              label: 'Healthy Products',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🎯 Recommended For You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: Obx(() {
            if (controller.isLoadingPharmacies.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.recommendation.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.recommend, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'No recommendations yet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Scan more products to get personalized recommendations',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: controller.recommendation.length,
              itemBuilder: (context, index) {
                final product = controller.recommendation[index];
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              child: Image.network(
                                product.imageUrl ?? '',
                                height: 120, // Reduced height
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 120,
                                    color: Colors.grey[200],
                                    child:
                                        const Icon(Icons.image_not_supported),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name ?? 'Unknown Product',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14, // Reduced font size
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4), // Reduced spacing
                                if (product.allergens?.isNotEmpty ?? false)
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: (product.allergens ?? [])
                                        .take(2)
                                        .map((allergen) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2), // Reduced padding
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          allergen,
                                          style: TextStyle(
                                            fontSize: 10, // Reduced font size
                                            color: Colors.red[900],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                const Spacer(), // Push button to bottom
                                TextButton(
                                  onPressed: () {
                                    Get.toNamed('/product/alternative',
                                        arguments: product.id);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        const Size(50, 24), // Reduced height
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('See Details →'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildNearbyPharmacies() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🏪 Nearby Pharmacies',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () => Get.toNamed('/pharmacy'),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('See All'),
              ),
            ],
          ),
          Obx(() {
            if (controller.isLoadingPharmacies.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.error.value != null) {
              return Center(
                child: Text(
                  'Failed to load pharmacies',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            if (pharmacyController.pharmacies.isEmpty) {
              return const Center(
                child: Text('No pharmacies found nearby'),
              );
            }

            return PharmacySection(
              pharmacies: pharmacyController.pharmacies,
            );
          }),
        ],
      ),
    );
  }
}
