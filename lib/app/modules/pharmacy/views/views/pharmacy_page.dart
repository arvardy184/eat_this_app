import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pharmacy_controller.dart';
import 'pharmacy_detail_page.dart';

class PharmacyPage extends StatelessWidget {
  final PharmacyController controller = Get.put(PharmacyController());

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

        return RefreshIndicator(
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
                title: Text(pharmacy.name),
                subtitle:
                    Text("${pharmacy.distance.toStringAsFixed(2)} meters away"),
                onTap: () {
                  Get.to(() => PharmacyDetailPage(pharmacyId: pharmacy.id));
                },
              );
            },
          ),
        );
      }),
    );
  }
}