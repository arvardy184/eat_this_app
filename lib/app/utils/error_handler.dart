import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ErrorHandler {
  static Future<void> handleUnauthorized() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('auth_token');
    Get.offAllNamed('/login');
    Get.snackbar('Session Expired', 'Please login again.');
  }
}