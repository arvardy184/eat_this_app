import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/allergen_model.dart';
import 'package:eat_this_app/app/data/models/user_model.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends BaseController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); 
  final RxBool isPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
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

  Future<void> changePassword() async {
    try {
      if (!validatePasswords()) return;

      isLoading.value = true;
      final response = await _userService.changePassword(
        oldPasswordController.text,
        newPasswordController.text,
      );

      if (response.token != null) {
        showSuccess('Password changed successfully');
        print("Success");
        Get.back(); // Close the change password page
        // Clear controllers
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
  bool validatePasswords() {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showError('All fields are required');
      return false;
    }

    if (newPasswordController.text.length < 6) {
      showError('New password must be at least 6 characters long');
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      showError('New passwords do not match');
      return false;
    }

    return true;
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
       print("data user profile ${user.value}");
      print("Error loading user profile: $e");
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
  Map<String, dynamic>? data,
  List<String>? allergens,
}) async {
  try {
    isLoading.value = true;

    // Update user data if provided
    if (data != null && data.isNotEmpty) {
      final response = await _userService.updateProfile(
        data['image_path'],
        data['name'],
        data['birth_date'],
        almaMater: data['alma_mater'],
        specialization: data['specialization'],
        address: data['address'],
        latitude: data['latitude'],
        longitude: data['longitude'],
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
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
