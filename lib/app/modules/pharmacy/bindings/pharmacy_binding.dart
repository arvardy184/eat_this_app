import 'package:eat_this_app/app/modules/pharmacy/controllers/pharmacy_controller.dart';
import 'package:get/get.dart';

class PharmacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyController>(() => PharmacyController());
  }
}
