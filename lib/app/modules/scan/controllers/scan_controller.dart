import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/services/product_service.dart';

import 'package:get/get.dart';
class ScanController extends BaseController {
  final ProductService _productService = ProductService();
  final isScanning = true.obs;
  final Rx<ProductModel?> productData = Rx<ProductModel?>(null);

  void toggleScanning() {
    isScanning.value = !isScanning.value;
    if (isScanning.value) productData.value = null;
  }

  Future<void> handleDetection(String barcode) async {
    try {
      isScanning.value = false;
      isLoading.value = true;
      
      productData.value = await _productService.fetchProductData(barcode);
      
      if (productData.value?.product != null) {
        print("Product found: ${productData.value?.product?.name}");
        showSuccess('Product found successfully');
      } else {
        showError('No product found for this barcode');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    productData.value = null;
    super.onClose();
  }
}