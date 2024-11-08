import 'package:get/get.dart';
import '../controllers/search_controllers.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchControllers());
  }
}
