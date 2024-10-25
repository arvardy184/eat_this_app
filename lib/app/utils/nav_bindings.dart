import 'package:eat_this_app/app/utils/nav_controller.dart';
import 'package:get/get.dart';

class NavBindings  extends Bindings{
  @override
  void dependencies() {
    Get.put<BottomNavController>(BottomNavController());
  }
}