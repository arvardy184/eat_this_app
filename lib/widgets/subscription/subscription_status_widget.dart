import 'package:eat_this_app/app/modules/chat/controllers/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionStatusWidget extends StatelessWidget

{

SubscriptionStatusWidget({super.key});

 
  @override
  Widget build(BuildContext context) {
     final SubscriptionController controller = Get.find<SubscriptionController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.isPremium.value
                        ? 'Premium Package'
                        : 'Free Package',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: controller.isPremium.value
                          ? Colors.blue[900]
                          : Colors.grey[600],
                    ),
                  ),
                  if (!controller.isPremium.value)
                    ElevatedButton(
                      onPressed: controller.showUpgradeDialog,
                      child: Text('Upgrade'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _buildQuotaInfo(
                'Remaining Scans',
                controller.remainingScans.value,
                controller.isPremium.value,
              ),
             const SizedBox(height: 8),
              _buildQuotaInfo(
                'Remaining Consultations',
                controller.remainingConsultations.value,
                controller.isPremium.value,
              ),
            ],
          ),
        ),
      );
    });
  }

Widget _buildQuotaInfo(String label, int value, bool isPremium) {
  return Row(
    children: [
      Icon(
        isPremium ? Icons.all_inclusive : Icons.timer,
        size: 20,
        color: Colors.grey[600],
      ),
      SizedBox(width: 8),
      Flexible(
        child: Text(
          '$label: ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          overflow: TextOverflow.clip, // Tambahkan jika diperlukan
        ),
      ),
      // SizedBox(width: 8),
      Flexible(
        
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            isPremium ? 'Unlimited' : '$value remaining',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: value > 0 ? Colors.blue[900] : Colors.red,
            ),
            overflow: TextOverflow.ellipsis, // Tambahkan jika diperlukan
          ),
        ),
      ),
    ],
  );
}

}
