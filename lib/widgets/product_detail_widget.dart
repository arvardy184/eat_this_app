import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetailWidget extends StatelessWidget {
  final Product product;

  ProductDetailWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
            Center(
              child: Image.network(
                product.imageUrl!,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          SizedBox(height: 16),
          Text(
            product.name ?? 'Unknown Product',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (product.description != null)
            Text(
              product.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          SizedBox(height: 16),
          _buildInfoRow('Quantity', product.quantity),
          _buildInfoRow('Nutriscore', product.nutriscore),
          Divider(),
          SizedBox(height: 8),
          Text(
            'Ingredients',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(product.ingredients ?? 'No ingredients information available'),
          SizedBox(height: 16),
          Text(
            'Allergens',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          if (product.allergens != null && product.allergens!.isNotEmpty)
            Wrap(
              spacing: 8,
              children: product.allergens!.map((allergen) => Chip(
                label: Text(allergen.name ?? ''),
                backgroundColor: Colors.red[100],
                labelStyle: TextStyle(color: Colors.red[900]),
              )).toList(),
            )
          else
            Text('No allergens information available'),
          SizedBox(height: 16),
          Text(
            'Categories',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          if (product.categories != null && product.categories!.isNotEmpty)
            Wrap(
              spacing: 8,
              children: product.categories!.map((category) => Chip(
                label: Text(category.value ?? ''),
                backgroundColor: Colors.blue[100],
                labelStyle: TextStyle(color: Colors.blue[900]),
              )).toList(),
            )
          else
            Text('No categories information available'),
          SizedBox(height: 16),
          if (product.nutrients != null)
            _buildNutrientsTable(product.nutrients!),
          SizedBox(height: 16),
          Text(
            'Additional Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          _buildInfoRow('Created At', product.createdAt),
          _buildInfoRow('Updated At', product.updatedAt),
        ],
      ),
    );
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
            _buildNutrientRow('Energy', nutrients.energy, nutrients.unit),
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
}