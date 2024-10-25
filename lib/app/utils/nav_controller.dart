// lib/app/utils/bottom_nav_controller.dart
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.toNamed('/beranda');
        break;
      case 1:
        Get.toNamed('/search');
        break;
      case 2:
        Get.toNamed('/scan');
        break;
      case 3:
        Get.toNamed('/pharmacy');
        break;
      case 4:
        Get.toNamed('/chat');
        break;
    }
  }
}