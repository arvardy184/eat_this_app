import 'package:eat_this_app/widgets/home/pharmacy_item.dart';
import 'package:flutter/material.dart';

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