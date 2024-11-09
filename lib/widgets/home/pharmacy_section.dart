import 'package:eat_this_app/app/data/models/pharmacy_model.dart';
import 'package:eat_this_app/app/modules/pharmacy/views/pharmacy_detail_page.dart';
import 'package:flutter/material.dart';

class PharmacySection extends StatelessWidget {
  final List<Pharmacy> pharmacies;

  const PharmacySection({
    super.key,
    required this.pharmacies,
  });

  String _truncateAddress(String address) {
    final words = address.split(' ');
    if (words.length <= 10) return address;
    return '${words.take(10).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final pharmacy = pharmacies[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PharmacyDetailPage(
                  pharmacyId: pharmacy.id,
                  latitude: pharmacy.latitude,
                  longitude: pharmacy.longitude,
                  name: pharmacy.name,
                ),
              ),
            );
          },
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.network(
                        pharmacy.profilePicture,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            child: const Icon(
                              Icons.store,
                              color: Colors.white,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pharmacy.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _truncateAddress(pharmacy.address),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${pharmacy.distance.toStringAsFixed(1)} KM Away',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
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
      },
    );
  }
}
