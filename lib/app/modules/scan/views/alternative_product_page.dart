// pages/alternative_product_page.dart
import 'package:eat_this_app/app/modules/scan/controllers/alternative_controller.dart';
import 'package:eat_this_app/widgets/product/product_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../data/models/product_model.dart';

class AlternativeProductPage extends GetView<AlternativeProductController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : ProductDetailWidget(
              productData: controller.productData.value ?? ProductModel(),
              onRefreshAlternatives: controller.refreshAlternatives,
              isLoadingAlternatives: controller.isLoadingAlternatives.value,
              alternativeProducts: controller.alternativeProducts,
            )),
    );
  }
}