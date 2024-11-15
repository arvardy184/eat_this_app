import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/alternative_model.dart';
import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/app/modules/chat/controllers/subscription_controller.dart';
import 'package:eat_this_app/app/modules/home/controllers/home_controller.dart';
import 'package:eat_this_app/app/utils/error_handler.dart';
import 'package:eat_this_app/services/package_service.dart';
import 'package:eat_this_app/services/product_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
class ScanController extends BaseController {
  final ProductService _productService = ProductService();
  final isScanning = true.obs;
  final Rx<ProductModel?> productData = Rx<ProductModel?>(null);
  final alternativeProducts = <Products>[].obs;
  final isLoadingAlternatives = false.obs;
  final isMax = false.obs;
  final subscriptionController = Get.put(SubscriptionController(
    Get.find<PackageService>(),
    packageService: PackageService(ApiProvider()),
  ));
  final HomeController homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    ever(productData, (_) => loadInitialAlternatives());
  }

  void toggleScanning() {
    isScanning.value = !isScanning.value;
    if (isScanning.value) {
      productData.value = null;
      alternativeProducts.clear();
    }
  }

  Future<void> handleDetection(String barcode) async {
    try {
      isScanning.value = false;
      isLoading.value = true;

      // Cek subscription sebelum scan
      if (subscriptionController.dailyScanCount.value >= 
          subscriptionController.remainingScans.value || 
          !subscriptionController.isPremium.value) {
        print("Scan limit check: ${subscriptionController.dailyScanCount.value} >= ${subscriptionController.remainingScans.value}");
        print("Premium status: ${subscriptionController.isPremium.value}");
        isLoading.value = false;
        return subscriptionController.showUpgradeDialog();
      }

      final result = await _productService.fetchProductData(barcode);
      if (result.product != null) {
        productData.value = result;
        print("Product found: ${result.product?.name}");
        showSuccess('Product found successfully');
        
        // Increment scan count after successful scan
        await subscriptionController.incrementDailyScanCount();
        await homeController.loadRecentScans();
        homeController.update();
      } else {
        showError('No product found for this barcode');
      }
    } on DioException catch (e) {
      print("DioException caught: ${e.type}, Status: ${e.response?.statusCode}");
      isLoading.value = false;
      
      // Handle different status codes
      switch (e.response?.statusCode) {
        case 400:
          if (e.response?.data?['message']!) {
            subscriptionController.showUpgradeDialog();
          } else {
            showError('Invalid request. Please try again.');
          }
          break;
          
        case 401:
          showError('Session expired. Please login again.');
          await ErrorHandler.handleUnauthorized();
          break;
          
        case 404:
          showError('Product not found');
          break;
          
        case 423:
          showError('Service temporarily locked. Please try again later.');
          break;
          
        case 429:
          showError('Too many requests. Please wait a moment and try again.');
          break;
          
        case 500:
          showError('Server error. Please try again later.');
          break;
          
        default:
          if (e.type == DioExceptionType.connectionTimeout) {
            showError('Connection timeout. Please check your internet connection.');
          } else if (e.type == DioExceptionType.connectionError) {
            showError('Connection error. Please check your internet connection.');
          } else {
            showError('An error occurred. Please try again.');
          }
      }
      
      // Reset state on error
      isScanning.value = true;
      productData.value = null;
      alternativeProducts.clear();
      
    } catch (e) {
      print("General error caught: $e");
      isLoading.value = false;
      showError('An unexpected error occurred');
      
      // Reset state on error
      isScanning.value = true;
      productData.value = null;
      alternativeProducts.clear();
      
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadInitialAlternatives() async {
    if (productData.value?.product?.keywords != null) {
      final keywords = productData.value!.product!.keywords!.split(',');
      await refreshAlternatives(keywords);
    }
  }

  Future<void> refreshAlternatives(List<String> keywords) async {
    try {
      isLoadingAlternatives(true);
      alternativeProducts.clear();
     if(keywords.isEmpty) return;
     
      final results = await _productService.getAlternative(keywords);
      print("Alternative products found: ${results.length}");
      
      final currentProductId = productData.value?.product?.id;
      final filtered = results.where((p) => p.id != currentProductId).toList();
      
      print("Filtered alternative products: ${filtered.length}");
      alternativeProducts.assignAll(filtered);
      
    } catch (e) {
      print("Error loading alternatives: $e");
      // Don't show error for alternatives, just leave the list empty
      alternativeProducts.clear();
    } finally {
      isLoadingAlternatives(false);
    }
  }

  void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
    );
  }

  void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
    );
  }

  @override
  void onClose() {
    productData.value = null;
    alternativeProducts.clear();
    super.onClose();
  }
}