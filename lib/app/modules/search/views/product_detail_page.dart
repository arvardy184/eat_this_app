import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/modules/scan/controllers/alternative_controller.dart';
import 'package:eat_this_app/widgets/product/product_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailPage extends StatelessWidget {
  final AlternativeProductController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      print("Product name: ${controller.productData}");

      return Scaffold(
        appBar: AppBar(
          title: Text(
              controller.productData.value?.product?.name ?? 'Product Details'),
        ),
        body: ProductDetailWidget(
          productData: controller.productData.value ?? ProductModel(),
          onRefreshAlternatives: (keywords) =>
              controller.refreshAlternatives(keywords),
          isLoadingAlternatives: controller.isLoadingAlternatives.value,
          alternativeProducts: controller.alternativeProducts,
          isLoading: controller.isLoading.value,
        ),
      );
    });
  }
}
