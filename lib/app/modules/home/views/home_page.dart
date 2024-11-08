import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/modules/chat/controllers/subscription_controller.dart';
import 'package:eat_this_app/app/modules/home/controllers/home_controller.dart';
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
  HomePage({Key? key}) : super(key: key);

final SubscriptionController subscriptionController = Get.put(SubscriptionController(Get.find<PackageService>(), packageService: PackageService(ApiProvider())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(controller: controller),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<SubscriptionController>(
                        init: subscriptionController,
                        builder: (controller) => SubscriptionStatusWidget(),
                      ),
                      _buildRecentScansSection(),
                      _buildStatsSection(),

                      Obx(() => RecommendationSection(
                        recommendations: controller.recommendation,
                        isLoading: controller.isLoadingPharmacies.value,
                      )),
                      _buildPharmacySection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    
    );
  }

  Widget _buildRecentScansSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Last Scanned',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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

            if (controller.error.value != null) {
              print("error ${controller.error.value}");
              return Center(
                child: Text(
                  'Product Not Found',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (controller.recentScans.isEmpty) {
              return const Center(
                child: Text('No recent scans'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: controller.recentScans.length,
              itemBuilder: (context, index) {
                final scan = controller.recentScans[index];
                return ProductHistoryCard(product: scan);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [CIETTheme.primary_color, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(Icons.qr_code_scanner,
                      color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                        '${controller.recentScans.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const Text(
                    'Scanned Items',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 50,
              color: Colors.white.withOpacity(0.5),
            ),
           Expanded(
              child: Column(
                children: [
                 const Icon(Icons.trending_up, color: Colors.white, size: 32),
                 const SizedBox(height: 8),
                 Obx(() => Text(
                  '${controller.healthyPercentage.value.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                 const  Text(
                    'Healthy Products',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPharmacySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nearby Pharmacies',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed('/pharmacies'),
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const PharmacySection(),
        ],
      ),
    );
  }
}






