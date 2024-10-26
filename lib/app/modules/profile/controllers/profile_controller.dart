import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/allergen_model.dart';
import 'package:eat_this_app/app/data/models/user_model.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/services/user_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends BaseController {
  final UserService _userService = UserService();
  final Rx<User?> user = Rx<User?>(null);
  final ImagePicker _picker = ImagePicker();
  final RxList<Allergen> allergens = <Allergen>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    loadAllergens();
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

  Future<void> updateProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        isLoading.value = true;
        final response = await _userService.updateProfile(
          image.path,
          user.value?.name,
          user.value?.birthDate, // Now this is String?
        );
        user.value = response.user;
        showSuccess('Profile picture updated successfully');
        await loadUserProfile();
      }
    } catch (e) {
      print('Error picking image: $e');
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

  Future<void> updateUserInfo({
    String? name,
    String? dateOfBirth,
    List<String>? allergens,
  }) async {
    try {
      isLoading.value = true;

      // Update basic info if provided
      if (name != null || dateOfBirth != null) {
        final response = await _userService.updateProfile(
          null,
          name,
          dateOfBirth, // Already in correct format YYYY-MM-DD
        );
        user.value = response.user;
      }

      // Update allergens if provided
      if (allergens != null && allergens.isNotEmpty) {
        await _userService.updateUserAllergens(allergens);
      }

      await loadUserProfile();
    } catch (e) {
      print('Error updating user info: $e');
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAllergens() async {
    try {
      final allAllergens = await _userService.getAllergens();
      final userAllergens = user.value?.allergens ?? [];

      // Set selected status for each allergen
      for (var allergen in allAllergens) {
        allergen.isSelected = userAllergens.any((a) => a.name == allergen.name);
      }

      allergens.value = allAllergens;
    } catch (e) {
      print('Error loading allergens: $e');
      handleError(e);
    }
  }

  void toggleAllergen(int index) {
    final allergen = allergens[index];
    allergen.isSelected = !allergen.isSelected;
    allergens.refresh();
  }

  List<String> get selectedAllergens =>
      allergens.where((a) => a.isSelected).map((a) => a.name).toList();

  @override
  void onClose() {
    user.value = null;
    super.onClose();
  }
}
