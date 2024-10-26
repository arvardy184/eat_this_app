// lib/app/controllers/base_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;

  void handleError(dynamic error) {
    isLoading.value = false;
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          showError('Connection timeout. Please try again.');
          break;
        case DioExceptionType.badResponse:
          switch (error.response?.statusCode) {
            case 401:
              handleUnauthorized();
              break;
            case 404:
              showError('Resource not found');
              break;
            default:
              showError(
                  error.response?.data['message'] ?? 'Something went wrong');
          }
          break;
        default:
          showError('Network error occurred');
      }
    } else {
      showError(error.toString());
    }
  }

  void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
    );
  }

  void handleUnauthorized() {
    Get.offAllNamed('/login');
    showError('Session expired. Please login again.');
  }

  void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
    );
  }
}
