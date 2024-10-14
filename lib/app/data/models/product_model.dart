class Product {
  final String id;
  final String name;
  final String barcode;
  final List<String> ingredients;
  final List<String> allergens;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.ingredients,
    required this.allergens,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      ingredients: List<String>.from(json['ingredients']),
      allergens: List<String>.from(json['allergens']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'ingredients': ingredients,
      'allergens': allergens,
    };
  }
}