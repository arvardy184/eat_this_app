import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseAuth {
  final ApiService _apiService = ApiService();

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      if (response.statusCode == 200) {
        // Handle successful login
         await _saveSession(response.data['token']);
        Get.offAllNamed('/home'); // Navigate to home page
      } else {
        // Handle login failure
        Get.snackbar('Login Failed', 'Please check your credentials');
      }
    } catch (e) {
      // Handle errors
      Get.snackbar('Error', 'An error occurred during login');
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      final response = await _apiService.signup(name, email, password);
      if (response.statusCode == 201) {
        // Handle successful signup
        Get.snackbar('Signup Successful', 'Please login with your new account');
        Get.offAllNamed('/login'); // Navigate to login page
      } else {
        // Handle signup failure
        Get.snackbar('Signup Failed', 'Please try again');
      }
    } catch (e) {
      // Handle errors
      Get.snackbar('Error', 'An error occurred during signup');
    }
  }
 Future<void> _saveSession(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

   Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Get.offAllNamed('/login');
  }

   Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

}
