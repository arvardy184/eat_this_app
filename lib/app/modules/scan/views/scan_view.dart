import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/modules/scan/controllers/scan_controller.dart';
import 'package:eat_this_app/widgets/product/product_detail_widget.dart';
import 'package:eat_this_app/widgets/product/scanner_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanPage extends StatelessWidget {
  final ScanController controller = Get.put(ScanController());

  ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Obx(
              () => controller.isScanning.value
                  ? Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: ScannerWidget(onDetect: controller.handleDetection),
                      ),
                    )
                  : ProductDetailWidget(
  productData: controller.productData.value ?? ProductModel(),
  onRefreshAlternatives: (keywords) => controller.refreshAlternatives(keywords),
  isLoadingAlternatives: controller.isLoadingAlternatives.value,
  alternativeProducts: controller.alternativeProducts,
)
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: controller.toggleScanning,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Obx(() => Text(
                controller.isScanning.value ? 'Stop Scanning' : 'Scan Again',
                style: const TextStyle(fontSize: 16),
              )),
            ),
          ),
        ],
      ),
    );
  }
}