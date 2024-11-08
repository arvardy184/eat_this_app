import 'package:eat_this_app/app/data/models/alternative_model.dart';
import 'package:eat_this_app/app/data/models/product_model.dart';
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
    if(isLoading){
      return const ProductDetailShimmer();
    }

    
    final product = productData.product;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image Section
          if (product?.imageUrl != null)
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.network(
                      product?.imageUrl ?? '',
                      height: 200,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

          // Product Info Section
          Container(
            padding: EdgeInsets.all(16),
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
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getNutriscoreColor(product?.nutriscore),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Nutriscore ${product?.nutriscore?.toUpperCase() ?? ""}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),

                // Product Description
                if (product?.keywords != null)
                  Card(
                    elevation: 0,
                    color: CIETTheme.primary_color,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        product?.keywords ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                SizedBox(height: 16),

                // Ingredients Section
                _buildSectionTitle(context, 'Ingredients'),
                Card(
                  elevation: 0,
                  color: Colors.grey[50],
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      product?.ingredients ?? 'No ingredients information available',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Allergens Section
                _buildSectionTitle(context, 'Allergens'),
                if (product?.allergens != null && product!.allergens!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.allergens!.map((allergen) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_amber_rounded, 
                            size: 16, 
                            color: Colors.red[900]
                          ),
                          SizedBox(width: 4),
                          Text(
                            allergen.name ?? '',
                            style: TextStyle(
                              color: Colors.red[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  )
                else
              const  Text('No allergens information available'),
               const SizedBox(height: 16),

                // Categories Section
                _buildSectionTitle(context, 'Categories'),
                if (product?.categories != null && product!.categories!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.categories!.map((category) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: CIETTheme.primary_color),
                      ),
                      child: Text(
                        category.value ?? '',
                        style: TextStyle(
                          color: CIETTheme.primary_color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  )
                else
                const  Text('No categories information available'),
               const  SizedBox(height: 24),

                // Nutrients Section
                if (product?.nutrients != null)
                  _buildNutrientsTable(product!.nutrients!),
               const  SizedBox(height: 24),

                // Additional Info Section
                _buildSectionTitle(context, 'Additional Information'),
                Card(
                  elevation: 0,
                  color: Colors.grey[50],
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                       //gatau masukin apa
                        Divider(),
                       SizedBox(height: 24),
                        _buildAlternativeProducts(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: CIETTheme.primary_color,
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



  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildNutrientsTable(Nutrients nutrients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutritional Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.grey[300]!),
          children: [
            TableRow(
              children: [
                _buildTableCell('Nutrient', isHeader: true),
                _buildTableCell('Amount', isHeader: true),
              ],
            ),
            _buildNutrientRow('Energy', nutrients.energy.toString(), nutrients.unit),
            _buildNutrientRow('Fat', nutrients.fat?.toString(), 'g'),
            _buildNutrientRow('Saturated Fat', nutrients.saturatedFat?.toString(), 'g'),
            _buildNutrientRow('Carbohydrate', nutrients.carbohydrate?.toString(), 'g'),
            _buildNutrientRow('Sugar', nutrients.sugar?.toString(), 'g'),
            _buildNutrientRow('Fiber', nutrients.fiber?.toString(), 'g'),
            _buildNutrientRow('Protein', nutrients.protein?.toString(), 'g'),
            _buildNutrientRow('Salt', nutrients.salt?.toString(), 'g'),
            _buildNutrientRow('Alcohol', nutrients.alcohol?.toString(), '%'),
          ],
        ),
        SizedBox(height: 8),
        Text('Serving size: ${nutrients.serving ?? 'N/A'} ${nutrients.unit ?? ''}'),
      ],
    );
  }

  TableRow _buildNutrientRow(String label, String? value, String? unit) {
    return TableRow(
      children: [
        _buildTableCell(label),
        _buildTableCell('${value ?? 'N/A'} ${unit ?? ''}'),
      ],
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


Widget _buildAlternativeProducts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Alternative Products',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: CIETTheme.primary_color,
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: CIETTheme.primary_color),
              onPressed: isLoadingAlternatives 
                ? null 
                : () => onRefreshAlternatives(
                    productData.product?.keywords?.split(',') ?? []
                  ),
            ),
          ],
        ),
        SizedBox(height: 8),
        
        if (isLoadingAlternatives)
          Center(child: CircularProgressIndicator())
        else if (alternativeProducts == null || alternativeProducts!.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'No alternative products found',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 280,
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
    );
  }
Widget _buildAlternativeCard(BuildContext context, Products product) {
    return Card(
      margin: EdgeInsets.only(right: 16, bottom: 4, top: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            
            // Product Name
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Unknown Product',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  
                  // Allergens
                  if (product.allergens != null && product.allergens!.isNotEmpty)
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: product.allergens!.take(3).map((allergen) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Text(
                            allergen,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red[900],
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                ],
              ),
            ),

            TextButton(
  onPressed: () {
    Get.toNamed('/product/alternative', arguments: product.id);
  },
  child: Text('View Details'),
  style: TextButton.styleFrom(
    minimumSize: Size(double.infinity, 36),
  ),
),
         
          ],
        ),
      ),
    );
  }
}