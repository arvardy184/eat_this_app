import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/modules/chat/controllers/subscription_controller.dart';
import 'package:eat_this_app/app/modules/home/controllers/home_controller.dart';
import 'package:eat_this_app/services/api_service.dart';
import 'package:eat_this_app/services/home_service.dart';
import 'package:eat_this_app/services/package_service.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class HomeBinding  implements Bindings{

  @override
  void dependencies() {
  Get.lazyPut(() => ApiService());
    Get.lazyPut(() => HomeService(Get.find<ApiService>()));
     Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PackageService(ApiProvider()));
    Get.lazyPut(() => SubscriptionController(Get.find<PackageService>(), packageService: PackageService(ApiProvider())));
  }
}