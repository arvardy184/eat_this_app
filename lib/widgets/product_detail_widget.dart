import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetailWidget extends StatelessWidget {
  final ProductModel productData;

  ProductDetailWidget({required this.productData});

  @override
  Widget build(BuildContext context) {
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
                if (product?.description != null)
                  Card(
                    elevation: 0,
                    color: Colors.blue[50],
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        product?.description ?? '',
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
              const    Text('No allergens information available'),
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
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        category.value ?? '',
                        style: TextStyle(
                          color: Colors.blue[900],
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
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                       //gatau masukin apa
                        Divider(),
                       
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
          color: Colors.blue[900],
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

  // ... rest of your methods remain the same
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
            _buildNutrientRow('Alcohol', nutrients.alcohol, '%'),
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
