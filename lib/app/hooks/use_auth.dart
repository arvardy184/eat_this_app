import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseAuth {
  final ApiProvider _apiService = ApiProvider();


  void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
    );
  }

  Future<void> login(String email, String password) async {
  try {
    final response = await _apiService.login(email, password);
    print("Response: $response");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Login successful");
    
      Get.offAllNamed('/home');  // Navigate to the home page
    } else {
      print("Login failed with status: ${response.statusCode}");
      Get.snackbar('Login Failed', 'Please check your credentials');
    }
  } catch (e) {
    print("Error during login: $e");
    Get.snackbar('Error', 'An error occurred during login');
  }
}



  Future<void> signup(String name, String email, String password) async {
    try {
      final response = await _apiService.signup(name, email, password);
      if (response.statusCode == 200 || response.statusCode == 201) {
         Get.offAllNamed('/home');
        showSuccess("Signup successful");
      } else {
        Get.snackbar('Signup Failed', 'Please check your credentials');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred during signup');
    }
  }

Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiService.forgotPassword(email);
      print("Response: $response");
      Get.toNamed('/otp', arguments: email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> verifyOtp(String email, String token) async {
    try {
      final response = await _apiService.verifyOTP(email, token);
      print("Response: $response");
      Get.toNamed('/reset-password', arguments: {
        'email': email,
        'token': token,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> resetPassword(String email, String token, String password) async {
    try {
      final response = await _apiService.resetPasswors(email, token, password);
      print("Response: $response");
      Get.offAllNamed('/login');
    } catch (e) {
      throw e;
    }
  
}


  Future<void> handleUnauthorized() async {
    try {
      await _apiService.refreshToken();
    } catch (e) {
      await logout();
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final refreshToken = prefs.getString('refresh_token');
    return token != null && refreshToken != null;
  }
}