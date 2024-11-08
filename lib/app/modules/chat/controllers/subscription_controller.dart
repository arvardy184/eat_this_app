import 'package:eat_this_app/app/data/models/package_model.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/app/themes/app_theme.dart';
import 'package:eat_this_app/services/package_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SubscriptionController extends BaseController {
  final PackageService packageService;
  final RxBool isPremium = false.obs;
  final RxInt remainingScans = 0.obs;
  final RxInt remainingConsultations = 0.obs;
  final RxBool isLoading = false.obs;
  final RxList<Packages> packages = <Packages>[].obs;
  final RxString email = ''.obs;

  SubscriptionController(PackageService find, {required this.packageService});

  @override

  void onInit() {
    super.onInit();
    checkSubscription();
    loadPackages();
  }


  Future<void> checkSubscription() async {
    try {
      isLoading(true);
      isPremium.value = await packageService.checkSubscription();
      remainingScans.value = await packageService.getRemainingScans();
      remainingConsultations.value =
          await packageService.getRemainingConsultations();
    } catch (e) {
      print("error checking subscription: $e");
    } finally {
      isLoading(false);
    }
  }

   Future<void> loadPackages() async {
    try {
      final packagesData = await packageService.getPackages();
      packages.assignAll(packagesData);
      print("packages: $packages");
    } catch (e) {
      print("Error loading packages: $e");
    }
  }

  Future<void> contactAdmin()async {
    final waUrl = packageService.getWhatsAppLink();
    launchUrlString(waUrl);
    print("launchUrlString: $waUrl");
  }


  void showUpgradeDialog() {
    // Pastikan ada paket premium
    final premiumPackage =
        packages.firstWhereOrNull((p) => p.name?.toLowerCase() == 'premium');

    if (premiumPackage == null) {
      Get.snackbar('Error', 'Premium package information not available');
      return;
    }

    Get.dialog(
      AlertDialog(
        title: Text('Upgrade to Premium'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Premium Package Benefits:'),
            SizedBox(height: 8),
            _buildBenefitItem('${premiumPackage.maxScan} Product Scans'),
            _buildBenefitItem(
                '${premiumPackage.maxConsultant} Expert Consultations'),
            _buildBenefitItem('Priority Support'),
            SizedBox(height: 16),
            Text(
              'Price: Rp ${premiumPackage.price}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text('Contact admin via WhatsApp to upgrade'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Later',style: TextStyle(color: CIETTheme.primary_color),),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              contactAdmin();
            },
            child: Text('Contact Admin',style: TextStyle(color: CIETTheme.primary_color),),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
