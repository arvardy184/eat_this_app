import 'package:eat_this_app/app/data/models/alternative_model.dart';
import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/services/product_service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AlternativeProductController extends GetxController {
  final ProductService _productService = Get.put(ProductService());
  final productData = Rx<ProductModel?>(null);
  final alternativeProducts = <Products>[].obs;
  final isLoadingAlternatives = false.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    
    print("Product ID di alternative: $args");

      print("Invalid arguments: $args");
       loadProductData(args.toString());
    
  }
  

  Future<void> loadProductData(String productId) async {
    try {
      isLoading(true);
      final result = await _productService.fetchProductData(productId);
      productData.value = result;
      print("loaded alternative product data: $result");
      // Load alternatives
      if (result.product?.keywords != null) {
        final keywords = result.product!.keywords!.split(',');
        await refreshAlternatives(keywords);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product details');
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshAlternatives(List<String> keywords) async {
    try {
      isLoadingAlternatives(true);
      if(keywords.isEmpty) return;
      
      final results = await _productService.getAlternative(keywords);

      // Remove current product from alternatives
      final filtered =
          results.where((p) => p.id != productData.value?.product?.id).toList();
      print("Alternative products found: ${filtered.length}");
      alternativeProducts.assignAll(filtered);
    } catch (e) {
      print('Error loading alternatives: $e');
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
