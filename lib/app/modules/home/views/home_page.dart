// lib/main.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(username: 'Rusmita'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LastScannedCard(
                        productName: 'Citato Ayam Bawang',
                        productType: 'Chips',
                        date: 'Sunday, 12 June',
                        time: '12:00 AM',
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Rekomendasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RecommendationSection(),
                      const SizedBox(height: 20),
                      const Text(
                        'Near Pharmacy',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PharmacySection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/widgets/custom_app_bar.dart
// import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;

  const CustomAppBar({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $username',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Welcome back!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/profile_image.png'),
            radius: 25,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

// lib/widgets/last_scanned_card.dart
// import 'package:flutter/material.dart';

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
            Image.asset('assets/images/citato_image.png',
                errorBuilder: (context, error, stackTrace) {
              // Fallback in case the image is not found
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey, // Grey background if image not found
                child: const Icon(Icons.broken_image,
                    color:
                        Colors.white), // Optional: an icon for visual feedback
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
                  ),
                  Text(productType),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(date),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(time),
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

// lib/widgets/recommendation_section.dart
// import 'package:flutter/material.dart';

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          RecommendationItem(name: 'Citato', image: 'assets/citato.png'),
          RecommendationItem(name: 'Biskuat', image: 'assets/biskuat.png'),
          RecommendationItem(name: 'Monde', image: 'assets/monde.png'),
          RecommendationItem(name: 'Nextar', image: 'assets/nextar.png'),
        ],
      ),
    );
  }
}

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
            // Fallback in case the image is not found
            return Container(
              width: 60,
              height: 60,
              color: Colors.grey, // Grey background if image not found
              child: const Icon(Icons.broken_image,
                  color: Colors.white), // Optional: an icon for visual feedback
            );
          }),
          const SizedBox(height: 4),
          Text(name, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// lib/widgets/pharmacy_section.dart
// import 'package:flutter/material.dart';

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
          image: 'assets/pharmacy_1.png',
        ),
        SizedBox(height: 12),
        PharmacyItem(
          name: 'Satan Pharmacy',
          location: 'Lumpur Pool',
          distance: '1.2 KM',
          rating: '',
          reviews: '',
          openTime: '',
          image: 'assets/pharmacy_2.png',
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
                  child: Icon(Icons.broken_image,
                      color: Colors.white), // Optional icon
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
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(location),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(distance,
                          style: const TextStyle(color: Colors.grey)),
                      if (rating.isNotEmpty) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.star, size: 16, color: Colors.yellow),
                        const SizedBox(width: 4),
                        Text('$rating ($reviews Reviews)',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                      if (openTime.isNotEmpty) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Open at $openTime',
                            style: const TextStyle(color: Colors.grey)),
                      ],
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

// lib/widgets/bottom_navigation.dart
// import 'package:flutter/material.dart';
