import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/modules/scan/controllers/scan_controller.dart';
import 'package:eat_this_app/widgets/product_detail_widget.dart';
import 'package:eat_this_app/widgets/scanner_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanPage extends StatelessWidget {
  final ScanController controller = Get.put(ScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Product')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Obx(
              () => controller.isScanning.value
                  ? SizedBox(
                      height: 300,
                      width: double.infinity,
                      child:
                          ScannerWidget(onDetect: controller.handleDetection),
                    )
                  : ProductDetailWidget(
                      productData: controller.productData.value ?? ProductModel(),),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: controller.toggleScanning,
                child: Obx(() => Text(controller.isScanning.value
                    ? 'Stop Scanning'
                    : 'Scan Again')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
