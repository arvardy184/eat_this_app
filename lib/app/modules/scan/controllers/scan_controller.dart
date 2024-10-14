// import 'package:get/get.dart';
// import 'package:can_i_eat_this/app/data/repositories/product_repository.dart';
// import 'package:can_i_eat_this/app/data/models/product_model.dart';

// class ScanController extends GetxController {
//   final ProductRepository productRepository;
  
//   ScanController({required this.productRepository});

//   final Rx<Product?> scannedProduct = Rx<Product?>(null);
//   final RxBool isLoading = false.obs;

//   Future<void> scanBarcode(String barcode) async {
//     try {
//       isLoading.value = true;
//       final product = await productRepository.getProductByBarcode(barcode);
//       scannedProduct.value = product;
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to scan product');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }