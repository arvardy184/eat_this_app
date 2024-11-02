// controllers/pharmacy_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:eat_this_app/app/data/models/pharmacy_model.dart';
import 'package:eat_this_app/services/pharmacy_service.dart';

class PharmacyController extends GetxController {
  final PharmacyService pharmacyService = PharmacyService();
  RxList<Pharmacy> pharmacies = <Pharmacy>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadNearbyPharmacies();
  }

  Future<void> _loadNearbyPharmacies() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Request location permission
      var status = await Permission.location.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        throw Exception('Location permission denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      print('Position obtained: ${position.latitude}, ${position.longitude}');

      // Get nearby pharmacies
      pharmacies.value = await pharmacyService.getNearbyPharmacies(
        position.latitude,
        position.longitude,
      );

      print('Pharmacies loaded: ${pharmacies.length}');
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

  Future<void> refreshPharmacies() async {
    await _loadNearbyPharmacies();
  }
}
