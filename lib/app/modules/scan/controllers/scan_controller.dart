import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/services/product_service.dart';
import 'package:get/get.dart';

class ScanController extends GetxController {
  final ProductService _productService = ProductService();
  final isScanning = true.obs;
  final isLoading = false.obs;
  final Rx<Product?> productData = Rx<Product?>(null);
  final Rx<Map<String, dynamic>> product = Rx<Map<String, dynamic>>({});

  void toggleScanning() {
    isScanning.value = !isScanning.value;
    if (isScanning.value) productData.value; // Set to null instead of empty map
  }

  Future<void> handleDetection(String barcode) async {
    isScanning.value = false;
    isLoading.value = true;
    try {
      productData.value = await _productService.fetchProductData(barcode);
      if (productData.value != null) {
        print("ProductModel is not null");
        if (productData.value != null) {
          print("Product is not null");
          print("Product details: ${productData.value?.toJson()}");
        } else {
          print("Product is null");
        }
      } else {
        print("ProductModel is null");
      }
      print("Product data: ${productData.value?.toJson()}");
      print("ising data ${productData.value?.name}");
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
