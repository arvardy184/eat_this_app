import 'package:eat_this_app/app/modules/scan/controllers/alternative_controller.dart';
import 'package:eat_this_app/services/product_service.dart';
import 'package:get/get.dart';

class AlternativeProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlternativeProductController(
      
    ),fenix: true);
    Get.lazyPut(() => ProductService());
  }
}