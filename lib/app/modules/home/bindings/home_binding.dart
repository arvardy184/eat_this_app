import 'package:eat_this_app/app/modules/home/controllers/home_controller.dart';
import 'package:eat_this_app/services/api_service.dart';
import 'package:eat_this_app/services/home_service.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class HomeBinding  implements Bindings{

  @override
  void dependencies() {
  Get.lazyPut(() => ApiService());
    Get.lazyPut(() => HomeService(Get.find<ApiService>()));
    Get.lazyPut(() => HomeController());
  }
}