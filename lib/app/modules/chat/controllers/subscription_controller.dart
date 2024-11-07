import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/services/package_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SubscriptionController extends BaseController{
  final PackageService packageService;
  final RxBool isPremium = false.obs;
  final RxInt remainingScans = 0.obs;
  final RxInt remainingConsultations = 0.obs;
  final RxBool isLoading = false.obs;

  SubscriptionController({required this.packageService});

  @override
  void onInit(){
    super.onInit();
    checkSubscription();
  }

  Future<void> checkSubscription() async{
    try{
      isLoading(true);
      isPremium.value = await packageService.checkSubscription();
      remainingScans.value = await packageService.getRemainingScans();
      remainingConsultations.value = await packageService.getRemainingConsultations();
    } catch(e){
      print("error checking subscription: $e");
    }finally{
      isLoading(false);
    }
}

void contactAdmin(){
  final waUrl = packageService.getWhatsAppLink();
 launchUrlString(waUrl);
 print("launchUrlString: $waUrl");
}
 void showUpgradeDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Upgrade to Premium'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get access to:'),
            SizedBox(height: 8),
            _buildBenefitItem('Unlimited Scans'),
            _buildBenefitItem('Expert Consultation'),
            _buildBenefitItem('Priority Support'),
            SizedBox(height: 16),
            Text('Contact admin via WhatsApp to upgrade'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              contactAdmin();
            },
            child: Text('Contact Admin'),
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
