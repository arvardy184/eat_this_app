import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ScanController extends GetxController {
  final ProductService _productService = ProductService();
  final isScanning = true.obs;
  final isLoading = false.obs;
  final Rx<ProductModel?> productData = Rx<ProductModel?>(null);

  void toggleScanning() {
    isScanning.value = !isScanning.value;
    if (isScanning.value) productData.value = null;
  }

  Future<void> handleDetection(String barcode) async {
    isScanning.value = false;
    isLoading.value = true;

    try {
      productData.value = await _productService.fetchProductData(barcode);
      
      if (productData.value?.product != null) {
        print("Product found: ${productData.value?.product?.name}");
      } else {
        print("No product data available");
        Get.snackbar(
          'Not Found',
          'No product found for this barcode',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print("Error in handleDetection: $e");
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }
}