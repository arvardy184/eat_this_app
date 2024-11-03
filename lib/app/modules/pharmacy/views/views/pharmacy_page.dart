import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/pharmacy_controller.dart';
import 'pharmacy_detail_page.dart';

class PharmacyPage extends StatelessWidget {
  final PharmacyController controller = Get.put(PharmacyController());
  final MapController mapController = MapController();

  PharmacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apotek Terdekat"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshPharmacies(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshPharmacies(),
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        }

        if (controller.pharmacies.isEmpty) {
          return const Center(
            child: Text("Tidak ditemukan apotek di sekitar."),
          );
        }

        final userPosition = controller.currentPosition.value;
        if (userPosition == null) {
          return const Center(child: Text("Mendapatkan lokasi..."));
        }

        return Column(
          children: [
            Expanded(
              flex: 1,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter:
                      LatLng(userPosition.latitude, userPosition.longitude),
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      // User location marker
                      Marker(
                        point: LatLng(
                            userPosition.latitude, userPosition.longitude),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      // Pharmacy markers
                      ...controller.pharmacies.map((pharmacy) {
                        return Marker(
                          point: LatLng(pharmacy.latitude, pharmacy.longitude),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  PharmacyDetailPage(pharmacyId: pharmacy.id));
                            },
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.local_pharmacy,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    pharmacy.name,
                                    style: const TextStyle(fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: RefreshIndicator(
                onRefresh: () => controller.refreshPharmacies(),
                child: ListView.builder(
                  itemCount: controller.pharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacy = controller.pharmacies[index];
                    return ListTile(
                      leading: pharmacy.profilePicture != null
                          ? Image.network(
                              pharmacy.profilePicture!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.local_pharmacy,
                                      size: 50, color: Colors.blue),
                            )
                          : const Icon(Icons.local_pharmacy,
                              size: 50, color: Colors.blue),
                      title: Text(pharmacy.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          "${pharmacy.distance.toStringAsFixed(2)} meters away"),
                      onTap: () {
                        mapController.move(
                            LatLng(pharmacy.latitude, pharmacy.longitude),
                            16.0);
                        Get.to(
                            () => PharmacyDetailPage(pharmacyId: pharmacy.id));
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
