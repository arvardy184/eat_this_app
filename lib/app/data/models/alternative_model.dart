class Products {
  String? id;
  String? keywords;
  String? imageUrl;
  String? name;
  String? ingredients;
  List<String>? allergens;

  Products({
    this.id,
    this.keywords,
    this.imageUrl,
    this.name,
    this.ingredients,
    this.allergens,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    // Handle allergens parsing
    List<String>? parseAllergens(dynamic allergensData) {
      if (allergensData == null) return [];
      
      if (allergensData is List) {
        return allergensData.map((e) => e.toString()).toList();
      }
      
      return [];
    }

    return Products(
      id: json['id'] as String?,
      keywords: json['keywords'] as String?,
      imageUrl: json['image_url'] as String?,
      name: json['name'] as String?,
      ingredients: json['ingredients'] as String?,
      allergens: parseAllergens(json['allergens']),
    );
  }

  // Untuk debugging
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keywords': keywords,
      'image_url': imageUrl,
      'name': name,
      'ingredients': ingredients,
      'allergens': allergens,
    };
  }

  @override
  String toString() {
    return 'Products(id: $id, name: $name, allergens: $allergens)';
  }
}

class GetAlternativeModel {
  String? status;
  List<Products>? products;

  GetAlternativeModel({
    this.status,
    this.products,
  });

  factory GetAlternativeModel.fromJson(Map<String, dynamic> json) {
    return GetAlternativeModel(
      status: json['status'] as String?,
      products: json['products'] != null
          ? (json['products'] as List)
              .map((product) => Products.fromJson(product as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}