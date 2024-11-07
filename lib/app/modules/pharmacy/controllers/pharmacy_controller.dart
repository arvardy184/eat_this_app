// controllers/pharmacy_controller.dart
import 'package:eat_this_app/app/data/models/user2_model.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/app/modules/pharmacy/views/pharmacy_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:eat_this_app/app/data/models/pharmacy_model.dart';
import 'package:eat_this_app/services/pharmacy_service.dart';

class PharmacyController extends BaseController {
  final PharmacyService pharmacyService = PharmacyService();
  RxList<Pharmacy> pharmacies = <Pharmacy>[].obs;
  RxList<Medicine> medicines = <Medicine>[].obs;
  RxList<Users> users = <Users>[].obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  final typeUser = ''.obs;
  final userId = ''.obs;
  final isPharmacy = false.obs;
  final isOwner = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      await loadUserId();
      await _initPharmacyStatus();
      await _loadNearbyPharmacies();
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> _initPharmacyStatus() async {
    try {
      final type = await pharmacyService.getType();
      typeUser.value = type ?? '';
      isPharmacy.value = type == 'Pharmacy';
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> redirectToPharmacyDetail() async {
    if (!isPharmacy.value || pharmacies.isEmpty) return;

    try {
      final pharmacy = pharmacies.firstWhere(
        (p) => p.id == userId.value,
        orElse: () => throw Exception('Pharmacy not found'),
      );

      isOwner.value = pharmacy.id == userId.value;

      Get.off(() => PharmacyDetailPage(
            pharmacyId: pharmacy.id,
            latitude: pharmacy.latitude,
            longitude: pharmacy.longitude,
            name: pharmacy.name,
          ));
    } catch (e) {
      handleError(e);
    }
  }

  // Metode terpisah untuk pengecekan dan redirect
  Future<void> checkPharmacyStatus() async {
    if (isLoading.value) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return isLoading.value;
      });
    }

    await redirectToPharmacyDetail();
  }

  Future<void> _loadNearbyPharmacies() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      var status = await Permission.location.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        throw Exception('Location permission denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      currentPosition.value = position;
      pharmacies.value = await pharmacyService.getNearbyPharmacies(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserId() async {
    try {
      final id = await pharmacyService.getUserId();
      userId.value = id ?? '';
      print("User id: $id");
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> refreshPharmacies() async {
    await _loadNearbyPharmacies();
  }

  Future<void> loadMedicines(String pharmacyId) async {
    try {
      isLoading.value = true;
      medicines.value = await pharmacyService.getPharmacyMedicines(pharmacyId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat daftar obat: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMedicine(
      String pharmacyId, String name, String content, String imageUrl) async {
    try {
      isLoading.value = true;
      await pharmacyService.addMedicine(pharmacyId, name, content, imageUrl);
      await loadMedicines(pharmacyId); // Refresh the list
      Get.snackbar(
        'Sukses',
        'Berhasil menambahkan obat',
        backgroundColor: Colors.green.shade100,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan obat: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMedicine(
      String medicineId, String name, String content, String imageUrl) async {
    try {
      isLoading.value = true;
      await pharmacyService.updateMedicine(medicineId, name, content, imageUrl);
      // Find and update the medicine in the local list
      final index = medicines.indexWhere((med) => med.id == medicineId);
      Get.snackbar(
        'Sukses',
        'Berhasil mengupdate obat',
        backgroundColor: Colors.green.shade100,
      );
      if (index != -1) {
        medicines[index] = Medicine(
          id: medicineId,
          name: name,
          content: content,
          imageUrl: imageUrl,
        );
        medicines.refresh(); // Notify GetX to update the UI
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengupdate obat: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMedicine(String medicineId) async {
    try {
      isLoading.value = true;
      await pharmacyService.deleteMedicine(medicineId);
      // Remove the medicine from the local list
      medicines.removeWhere((med) => med.id == medicineId);
      Get.snackbar(
        'Sukses',
        'Berhasil menghapus obat',
        backgroundColor: Colors.green.shade100,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus obat: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
