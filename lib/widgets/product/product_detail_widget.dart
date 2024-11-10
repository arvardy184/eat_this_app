import 'dart:ui';

import 'package:eat_this_app/app/data/models/alternative_model.dart';
import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/modules/scan/controllers/alternative_controller.dart';
import 'package:eat_this_app/app/themes/app_theme.dart';
import 'package:eat_this_app/widgets/product/shimmer_product_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProductDetailWidget extends StatelessWidget {
  final ProductModel productData;
  final Function(List<String>) onRefreshAlternatives;
  final List<Products>? alternativeProducts;
  final bool isLoadingAlternatives;
  final bool isLoading;

  const ProductDetailWidget({
    required this.productData,
    required this.onRefreshAlternatives,
    this.alternativeProducts,
    this.isLoadingAlternatives = false,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final arguments = Get.arguments;
    print("arguments $arguments");
    if (isLoading) {
      return const ProductDetailShimmer();
    }

    final product = productData.product;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image Section with Gradient Overlay
          if (product?.imageUrl != null)
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade50,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Hero(
                      tag: 'product-${product?.id}',
                      child: Image.network(
                        product?.imageUrl ?? '',
                        height: 250,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const CircularProgressIndicator();
                        },
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
                // Back button with blur effect
                // Positioned(
                //   top: 16,
                //   left: 16,
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(30),
                //     child: BackdropFilter(
                //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.white.withOpacity(0.3),
                //           borderRadius: BorderRadius.circular(30),
                //         ),
                //         child: IconButton(
                //           icon: const Icon(Icons.arrow_back_ios_new),
                //           color: Colors.black87,
                //           onPressed: () => Navigator.pop(context),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),

          // Product Info Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Nutriscore
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product?.name ?? 'Unknown Product',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    if (product?.nutriscore != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getNutriscoreColor(product?.nutriscore),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  _getNutriscoreColor(product?.nutriscore).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Nutriscore',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product?.nutriscore?.toUpperCase() ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Keywords/Description Card
                if (product?.keywords != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CIETTheme.primary_color.withOpacity(0.9),
                          CIETTheme.primary_color.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: CIETTheme.primary_color.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Product Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product?.keywords ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Quick Info Cards
                Row(
                  children: [
                    _buildInfoCard(
                      icon: Icons.shopping_basket,
                      title: 'Category',
                      value: product?.categories?.firstOrNull?.value ?? 'Unknown',
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    _buildInfoCard(
                      icon: Icons.scale,
                      title: 'Serving',
                      value: '${product?.nutrients?.serving ?? 'N/A'} ${product?.nutrients?.unit ?? ''}',
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Ingredients Section
                _buildExpandableSection(
                  title: 'Ingredients',
                  icon: Icons.restaurant_menu,
                  content: Text(
                    product?.ingredients ?? 'No ingredients information available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ),
                const SizedBox(height: 16),

                // Allergens Section with New Design
                if (product?.allergens != null && product!.allergens!.isNotEmpty)
                  _buildExpandableSection(
                    title: 'Allergens',
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.red[700],
                    content: Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: product.allergens!.map((allergen) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.red.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.shade100.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  size: 18, color: Colors.red[900]),
                              const SizedBox(width: 6),
                              Text(
                                allergen.name ?? '',
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 24),

                // Nutrients Section with New Design
                if (product?.nutrients != null)
                  _buildNutrientsTable(product!.nutrients!),
                const SizedBox(height: 32),

                // Alternative Products Section with New Design
                _buildAlternativeProducts(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    Color? iconColor,
    required Widget content,
  }) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Row(
          children: [
            Icon(icon, color: iconColor ?? CIETTheme.primary_color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: iconColor ?? CIETTheme.primary_color,
                fontSize: 18,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientsTable(Nutrients nutrients) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant, color: CIETTheme.primary_color),
                const SizedBox(width: 8),
                Text(
                  'Nutritional Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CIETTheme.primary_color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(1),
              },
              children: [
                _buildTableHeader(),
                _buildNutrientRow('Energy', nutrients.energy.toString(), nutrients.unit, isHighlighted: true),
                _buildNutrientRow('Fat', nutrients.fat?.toString(), 'g'),
                _buildNutrientRow('Saturated Fat', nutrients.saturatedFat?.toString(), 'g'),
                _buildNutrientRow('Carbohydrate', nutrients.carbohydrate?.toString(), 'g', isHighlighted: true),
                _buildNutrientRow('Sugar', nutrients.sugar?.toString(), 'g'),
                _buildNutrientRow('Fiber', nutrients.fiber?.toString(), 'g'),
                _buildNutrientRow('Protein', nutrients.protein?.toString(), 'g', isHighlighted: true),
                _buildNutrientRow('Salt', nutrients.salt?.toString(), 'g'),
                if (nutrients.alcohol != null)
                  _buildNutrientRow('Alcohol', nutrients.alcohol?.toString(), '%'),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Per serving: ${nutrients.serving ?? 'N/A'} ${nutrients.unit ?? ''}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        _buildTableCell('Nutrient', isHeader: true),
        _buildTableCell('Amount', isHeader: true, ),
      ],
    );
  }

  TableRow _buildNutrientRow(String label, String? value, String? unit, {bool isHighlighted = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.blue.shade50.withOpacity(0.3) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? CIETTheme.primary_color : Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            '${value ?? 'N/A'} ${unit ?? ''}',
            style: TextStyle(
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? CIETTheme.primary_color : Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildAlternativeProducts(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.switch_access_shortcut,
                    color: CIETTheme.primary_color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Healthier Alternatives',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CIETTheme.primary_color,
                          fontSize: 18
                        ),
                  ),
                ],
              ),
              IconButton.filled(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: isLoadingAlternatives
                    ? null
                    : () => onRefreshAlternatives(
                        productData.product?.keywords?.split(',') ?? []),
                style: IconButton.styleFrom(
                  backgroundColor: CIETTheme.primary_color.withOpacity(0.1),
                  foregroundColor: CIETTheme.primary_color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoadingAlternatives)
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text(
                    'Finding better alternatives...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else if (alternativeProducts == null || alternativeProducts!.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.search_off,
                      size: 48, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 8),
                  Text(
                    'No alternative products found',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Try refreshing or modifying your search',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 320,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: alternativeProducts!.length,
                itemBuilder: (context, index) {
                  final alternative = alternativeProducts![index];
                  return _buildAlternativeCard(context, alternative);
                },
              ),
            ),
        ],
      ),
    );
  }

    Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget _buildAlternativeCard(BuildContext context, Products product) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade50,
                      Colors.white,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        product.imageUrl ?? '',
                        height: 140,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    // Healthy badge
                    // Positioned(
                    //   top: 12,
                    //   right: 12,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 10,
                    //       vertical: 6,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: Colors.green.shade500,
                    //       borderRadius: BorderRadius.circular(20),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.green.shade200.withOpacity(0.5),
                    //           blurRadius: 4,
                    //           offset: const Offset(0, 2),
                    //         ),
                    //       ],
                    //     ),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         const Icon(
                    //           Icons.favorite,
                    //           color: Colors.white,
                    //           size: 14,
                    //         ),
                    //         const SizedBox(width: 4),
                    //         Text(
                    //           'Healthier',
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 12,
                    //             fontWeight: FontWeight.bold,
                    //             shadows: [
                    //               Shadow(
                    //                 color: Colors.black.withOpacity(0.2),
                    //                 offset: const Offset(0, 1),
                    //                 blurRadius: 2,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            // Content Container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? 'Unknown Product',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (product.allergens != null && product.allergens!.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: product.allergens!.take(2).map((allergen) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.warning_amber_rounded,
                                    size: 12, color: Colors.red.shade900),
                                const SizedBox(width: 4),
                                Text(
                                  allergen,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    const Spacer(),
                 ElevatedButton(
onPressed: () {
  print("Button pressed");
  if (product.id != null) {
    print("Product ID exists: ${product.id}");
    Get.delete<AlternativeProductController>();
    print("Controller deleted");
    Get.toNamed(
      '/product/alternative',
      arguments: product.id,
      preventDuplicates: false,
    );
    print("Navigation attempted");
  } else {
    print("Product ID is null");
  }
},
  style: ElevatedButton.styleFrom(
    backgroundColor: CIETTheme.primary_color,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    minimumSize: const Size(double.infinity, 40),
  ),
  child: const Text('View Details'),
),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    Color _getNutriscoreColor(String? score) {
    switch (score?.toLowerCase()) {
      case 'a': return Colors.green;
      case 'b': return Colors.lightGreen;
      case 'c': return Colors.yellow[700]!;
      case 'd': return Colors.orange;
      case 'e': return Colors.red;
      default: return Colors.grey;
    }
  }
}
// class ProductDetailWidget extends StatelessWidget {
//   final ProductModel productData;
//   final Function(List<String>) onRefreshAlternatives;
//   final List<Products>? alternativeProducts;
//   final bool isLoadingAlternatives;
//   final bool isLoading;

//    const ProductDetailWidget({
//     required this.productData,
//     required this.onRefreshAlternatives,
//     this.alternativeProducts,
//     this.isLoadingAlternatives = false,
//     this.isLoading = false,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if(isLoading){
//       return const ProductDetailShimmer();
//     }

    
//     final product = productData.product;
    
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Hero Image Section
//           if (product?.imageUrl != null)
//             Container(
//               width: double.infinity,
//               height: 250,
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//               ),
//               child: Stack(
//                 children: [
//                   Center(
//                     child: Image.network(
//                       product?.imageUrl ?? '',
//                       height: 200,
//                       fit: BoxFit.contain,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Center(child: CircularProgressIndicator());
//                       },
//                       errorBuilder: (context, error, stackTrace) => 
//                         Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//           // Product Info Section
//           Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Name and Nutriscore
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         product?.name ?? 'Unknown Product',
//                         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     if (product?.nutriscore != null)
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: _getNutriscoreColor(product?.nutriscore),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           'Nutriscore ${product?.nutriscore?.toUpperCase() ?? ""}',
//                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 8),

//                 // Product Description
//                 if (product?.keywords != null)
//                   Card(
//                     elevation: 0,
//                     color: CIETTheme.primary_color,
//                     child: Padding(
//                       padding: EdgeInsets.all(12),
//                       child: Text(
//                         product?.keywords ?? '',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: 16),

//                 // Ingredients Section
//                 _buildSectionTitle(context, 'Ingredients'),
//                 Card(
//                   elevation: 0,
//                   color: Colors.grey[50],
//                   child: Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Text(
//                       product?.ingredients ?? 'No ingredients information available',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),

//                 // Allergens Section
//                 _buildSectionTitle(context, 'Allergens'),
//                 if (product?.allergens != null && product!.allergens!.isNotEmpty)
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: product.allergens!.map((allergen) => Container(
//                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.red[100],
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.red[300]!),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.warning_amber_rounded, 
//                             size: 16, 
//                             color: Colors.red[900]
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             allergen.name ?? '',
//                             style: TextStyle(
//                               color: Colors.red[900],
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )).toList(),
//                   )
//                 else
//               const  Text('No allergens information available'),
//                const SizedBox(height: 16),

//                 // Categories Section
//                 _buildSectionTitle(context, 'Categories'),
//                 if (product?.categories != null && product!.categories!.isNotEmpty)
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: product.categories!.map((category) => Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[50],
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: CIETTheme.primary_color),
//                       ),
//                       child: Text(
//                         category.value ?? '',
//                         style: TextStyle(
//                           color: CIETTheme.primary_color,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     )).toList(),
//                   )
//                 else
//                 const  Text('No categories information available'),
//                const  SizedBox(height: 24),

//                 // Nutrients Section
//                 if (product?.nutrients != null)
//                   _buildNutrientsTable(product!.nutrients!),
//                const  SizedBox(height: 24),

//                 // Additional Info Section
//                 _buildSectionTitle(context, 'Additional Information'),
//                 Card(
//                   elevation: 0,
//                   color: Colors.grey[50],
//                   child: Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Column(
//                       children: [
//                        //gatau masukin apa
//                         Divider(),
//                        SizedBox(height: 24),
//                         _buildAlternativeProducts(context),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(BuildContext context, String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Text(
//         title,
//         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//           fontWeight: FontWeight.bold,
//           color: CIETTheme.primary_color,
//         ),
//       ),
//     );
//   }





//   Widget _buildInfoRow(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(value ?? 'N/A'),
//         ],
//       ),
//     );
//   }

//   Widget _buildNutrientsTable(Nutrients nutrients) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Nutritional Information',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         Table(
//           border: TableBorder.all(color: Colors.grey[300]!),
//           children: [
//             TableRow(
//               children: [
//                 _buildTableCell('Nutrient', isHeader: true),
//                 _buildTableCell('Amount', isHeader: true),
//               ],
//             ),
//             _buildNutrientRow('Energy', nutrients.energy.toString(), nutrients.unit),
//             _buildNutrientRow('Fat', nutrients.fat?.toString(), 'g'),
//             _buildNutrientRow('Saturated Fat', nutrients.saturatedFat?.toString(), 'g'),
//             _buildNutrientRow('Carbohydrate', nutrients.carbohydrate?.toString(), 'g'),
//             _buildNutrientRow('Sugar', nutrients.sugar?.toString(), 'g'),
//             _buildNutrientRow('Fiber', nutrients.fiber?.toString(), 'g'),
//             _buildNutrientRow('Protein', nutrients.protein?.toString(), 'g'),
//             _buildNutrientRow('Salt', nutrients.salt?.toString(), 'g'),
//             _buildNutrientRow('Alcohol', nutrients.alcohol?.toString(), '%'),
//           ],
//         ),
//         SizedBox(height: 8),
//         Text('Serving size: ${nutrients.serving ?? 'N/A'} ${nutrients.unit ?? ''}'),
//       ],
//     );
//   }

//   TableRow _buildNutrientRow(String label, String? value, String? unit) {
//     return TableRow(
//       children: [
//         _buildTableCell(label),
//         _buildTableCell('${value ?? 'N/A'} ${unit ?? ''}'),
//       ],
//     );
//   }

//   Widget _buildTableCell(String text, {bool isHeader = false}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         text,
//         style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
//       ),
//     );
//   }


// Widget _buildAlternativeProducts(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Alternative Products',
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: CIETTheme.primary_color,
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.refresh, color: CIETTheme.primary_color),
//               onPressed: isLoadingAlternatives 
//                 ? null 
//                 : () => onRefreshAlternatives(
//                     productData.product?.keywords?.split(',') ?? []
//                   ),
//             ),
//           ],
//         ),
//         SizedBox(height: 8),
        
//         if (isLoadingAlternatives)
//           Center(child: CircularProgressIndicator())
//         else if (alternativeProducts == null || alternativeProducts!.isEmpty)
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Icon(Icons.search_off, size: 48, color: Colors.grey),
//                   SizedBox(height: 8),
//                   Text(
//                     'No alternative products found',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         else
//           SizedBox(
//             height: 280,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: alternativeProducts!.length,
//               itemBuilder: (context, index) {
//                 final alternative = alternativeProducts![index];
//                 return _buildAlternativeCard(context, alternative);
//               },
//             ),
//           ),
//       ],
//     );
//   }
// Widget _buildAlternativeCard(BuildContext context, Products product) {
//     return Card(
//       margin: EdgeInsets.only(right: 16, bottom: 4, top: 4),
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Container(
//         width: 200,
//         padding: EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             Expanded(
//               flex: 3,
//               child: Center(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     product.imageUrl ?? '',
//                     fit: BoxFit.contain,
//                     errorBuilder: (context, error, stackTrace) =>
//                         Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
            
//             // Product Name
//             Expanded(
//               flex: 2,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name ?? 'Unknown Product',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4),
                  
//                   // Allergens
//                   if (product.allergens != null && product.allergens!.isNotEmpty)
//                     Expanded(
//                       child: Wrap(
//                         spacing: 4,
//                         runSpacing: 4,
//                         children: product.allergens!.take(3).map((allergen) => Container(
//                           padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: Colors.red[50],
//                             borderRadius: BorderRadius.circular(4),
//                             border: Border.all(color: Colors.red[200]!),
//                           ),
//                           child: Text(
//                             allergen,
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.red[900],
//                             ),
//                           ),
//                         )).toList(),
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             TextButton(
//   onPressed: () {
//     Get.toNamed('/product/alternative', arguments: product.id);
//   },
//   child: Text('View Details'),
//   style: TextButton.styleFrom(
//     minimumSize: Size(double.infinity, 36),
//   ),
// ),
         
//           ],
//         ),
//       ),
//     );
//   }
// }