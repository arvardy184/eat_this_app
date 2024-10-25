import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/user_model.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/services/user_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
class ProfileController extends BaseController {
  final UserService _userService = UserService();
  final Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final response = await _userService.getUserProfile();
      user.value = response.user;
      
      if (user.value == null) {
        showError('Failed to load user profile');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _userService.logout();
      Get.offAllNamed('/login');
      showSuccess('Logged out successfully');
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    user.value = null;
    super.onClose();
  }
}