import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseAuth {
  final ApiProvider _apiService = ApiProvider();

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
      } else {
        Get.snackbar('Signup Failed', 'Please check your credentials');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred during signup');
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