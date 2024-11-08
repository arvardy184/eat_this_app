import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/alternative_model.dart';
import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/app/modules/chat/controllers/subscription_controller.dart';
import 'package:eat_this_app/services/package_service.dart';
import 'package:eat_this_app/services/product_service.dart';

import 'package:get/get.dart';
class ScanController extends BaseController {
  final ProductService _productService = ProductService();
  final isScanning = true.obs;
  final Rx<ProductModel?> productData = Rx<ProductModel?>(null);
  final alternativeProducts = <Products>[].obs;
  final isLoadingAlternatives = false.obs;
  final isMax  = false.obs;
  final subscriptionController = Get.put(SubscriptionController( Get.find<PackageService>(), packageService: PackageService(ApiProvider())));

  @override
  void onInit() {
    super.onInit();
    ever(productData, (_) => loadInitialAlternatives());
  }

  void toggleScanning() {
    isScanning.value = !isScanning.value;
    if (isScanning.value) {
      productData.value = null;
      alternativeProducts.clear();
    }
  }

  Future<void> handleDetection(String barcode) async {
    try {
      isScanning.value = false;
      isLoading.value = true;
      
      productData.value = await _productService.fetchProductData(barcode);
      
      if (productData.value?.product != null) {
        print("Product found: ${productData.value?.product?.name}");
         if (subscriptionController.dailyScanCount.value >= subscriptionController.remainingScans.value 
      && !subscriptionController.isPremium.value) {
    subscriptionController.showUpgradeDialog();
    return;
  }
        showSuccess('Product found successfully');
        loadInitialAlternatives();

        await subscriptionController.incrementDailyScanCount();
      } else {
        showError('No product found for this barcode');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void loadInitialAlternatives() {
    if (productData.value?.product?.keywords != null) {
      final keywords = productData.value!.product!.keywords!.split(',');
      refreshAlternatives(keywords);
    }
  }

  Future<void> refreshAlternatives(List<String> keywords) async {
    try {
      isLoadingAlternatives(true);
      alternativeProducts.clear();
      
      final results = await _productService.getAlternative(keywords);
      print("Alternative products found: ${results.length}");
      
      // Remove current product from alternatives if present
      final currentProductId = productData.value?.product?.id;
      print("Current product ID: $currentProductId");
      final filtered = results.where((p) => p.id != currentProductId).toList();
      
      print("Alternative products found: ${filtered.length} after filtering");
      alternativeProducts.assignAll(filtered);
    } on DioException catch (e) {
      print("Error loading alternatives: $e");
    } finally {
      isLoadingAlternatives(false);
    }
  }

  @override
  void onClose() {
    productData.value = null;
    alternativeProducts.clear();
    super.onClose();
  }
}