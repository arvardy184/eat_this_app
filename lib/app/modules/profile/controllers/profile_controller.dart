import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/user_model.dart';
import 'package:eat_this_app/services/user_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProfileController extends GetxController {
  final UserService _userService = UserService();
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async{
    try{
      isLoading.value = true;
      final response = await _userService.getUserProfile();
      print("res profile $response");
      user.value = response.user;
    } on DioException catch(e){
      Get.snackbar('Error', 'Failed to load profile: $e');
      print("error $e");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async{
    await _userService.logout();
    Get.offAllNamed('/login');
  }
}