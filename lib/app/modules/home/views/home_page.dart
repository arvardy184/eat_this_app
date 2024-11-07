import 'package:eat_this_app/app/modules/home/controllers/home_controller.dart';
import 'package:eat_this_app/app/themes/app_theme.dart';
import 'package:eat_this_app/widgets/product/recommendation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eat_this_app/app/data/models/history_model.dart';
import 'package:eat_this_app/app/modules/home/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

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
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => Get.toNamed('/scanner'),
      //   icon: const Icon(Icons.qr_code_scanner),
      //   label: const Text('Scan Product'),
      // ),
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
              // TextButton(
              //   onPressed: () => Get.toNamed('/history'),
              //   child: const Text('See All'),
              // ),
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

class ProductHistoryCard extends StatelessWidget {
  final Products product;

  const ProductHistoryCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('MMM d, y').format(
      DateTime.parse(product.pivot?.createdAt ?? DateTime.now().toString()),
    );

    return GestureDetector(
      onTap: () {
        Get.toNamed('/product/alternative', arguments: product.id);
      },
      child: Container(
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  product.imageUrl ?? '',
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
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
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
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  HomeController controller = Get.put(HomeController());

   CustomAppBar(
      {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: CIETTheme.primary_color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Expanded(
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${controller.userData.value?.user?.name ?? 'User'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${controller.userData.value?.user?.package?.name ?? 'Free'} Package',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            )),
          ),
            Obx(() => GestureDetector(
            onTap: () => Get.toNamed('/profile'),
            child: ClipOval(
                child: controller.userData.value?.user?.profilePicture != null
                    ? Image.network(
                        controller.userData.value?.user?.profilePicture ?? '',
                        fit: BoxFit.cover,
                        // Error handling ketika gambar gagal dimuat
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading profile image: $error');
                          // Menampilkan fallback image atau placeholder
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          );
                        },
                        // Loading placeholder
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        size: 30,
                        ),
                      ),
              ),
            ),
          )
          // GestureDetector(
          //   onTap: () {
              
          //     Get.toNamed('/profile');
          //   },
          //   child: const CircleAvatar(
          //     backgroundImage: AssetImage('assets/images/farhan.png'),
          //     radius: 25,
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class LastScannedCard extends StatelessWidget {
  final String productName;
  final String productType;
  final String date;
  final String time;

  const LastScannedCard({
    super.key,
    required this.productName,
    required this.productType,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset('assets/images/farhan.png',
                errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey,
                child: const Icon(Icons.broken_image, color: Colors.white),
              );
            }, width: 60, height: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(productType, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(date, overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(time, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

// class RecommendationSection extends StatelessWidget {
//   const RecommendationSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: const [
//           RecommendationItem(name: 'Citato', image: 'assets/images/farhan.png'),
//           RecommendationItem(
//               name: 'Biskuat', image: 'assets/images/farhan.png'),
//           RecommendationItem(name: 'Monde', image: 'assets/images/farhan.png'),
//           RecommendationItem(name: 'Nextar', image: 'assets/images/farhan.png'),
//         ],
//       ),
//     );
//   }
// }

class RecommendationItem extends StatelessWidget {
  final String name;
  final String image;

  const RecommendationItem(
      {super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Image.asset(image, width: 60, height: 60,
              errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 60,
              height: 60,
              color: Colors.grey,
              child: const Icon(Icons.broken_image, color: Colors.white),
            );
          }),
          const SizedBox(height: 4),
          Text(name,
              textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class PharmacySection extends StatelessWidget {
  const PharmacySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PharmacyItem(
          name: '666 Pharmacy',
          location: 'Lowokwaru',
          distance: '1.2 KM',
          rating: '4.8',
          reviews: '120',
          openTime: '07:00',
          image: 'assets/images/farhan.png',
        ),
        SizedBox(height: 12),
        PharmacyItem(
          name: 'Satan Pharmacy',
          location: 'Lumpur Pool',
          distance: '1.2 KM',
          rating: '',
          reviews: '',
          openTime: '',
          image: 'assets/images/farhan.png',
        ),
      ],
    );
  }
}

class PharmacyItem extends StatelessWidget {
  final String name;
  final String location;
  final String distance;
  final String rating;
  final String reviews;
  final String openTime;
  final String image;

  const PharmacyItem({
    super.key,
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.openTime,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(image),
              onBackgroundImageError: (error, stackTrace) {
                // Use a grey circle avatar if image loading fails
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30,
                  child: Icon(Icons.broken_image, color: Colors.white),
                );
              },
              radius: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                  Text(location, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(distance,
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  if (rating.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.yellow),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text('$rating ($reviews Reviews)',
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  if (openTime.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text('Open at $openTime',
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
