import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioInterceptor  extends Interceptor{

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if(err.response?.statusCode == 401){
      await handleExpiredToken();
    }
    super.onError(err, handler);
  }

   Future<void> handleExpiredToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
    print("Session Expired di dio interceptor");
    // Navigate to login
    Get.offAllNamed('/login');
    Get.snackbar(
      'Session Expired',
      'Please login again',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
    );
  }
}