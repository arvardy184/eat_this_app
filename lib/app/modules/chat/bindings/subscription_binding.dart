import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/modules/chat/controllers/subscription_controller.dart';
import 'package:eat_this_app/services/package_service.dart';
import 'package:get/get.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionController(Get.find<PackageService>(), packageService: PackageService(ApiProvider())));
  }
}