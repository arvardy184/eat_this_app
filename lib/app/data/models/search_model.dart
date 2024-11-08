import 'package:eat_this_app/app/data/models/parse_allergens.dart';

class Products {
  String? id;
  String? keywords;
  String? name;
  String? imageUrl;
  String? ingredients;
  List<String>? allergens;

  Products({
    this.id,
    this.keywords,
    this.name,
    this.imageUrl,
    this.ingredients,
    this.allergens,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keywords = json['keywords'];
    name = json['name'];
    imageUrl = json['image_url'];
    ingredients = json['ingredients'];
    
    ProductHelper.debugPrintProduct(json);

    if (!ProductHelper.isValidProduct(json)) {
    print('Invalid product data: $json');
    throw Exception('Invalid product data');
  }
    // Handle different allergens formats
    if (json['allergens'] != null) {
      if (json['allergens'] is List) {
        allergens = List<String>.from(json['allergens']);
      } else if (json['allergens'] is Map) {
        // Convert Map values to List<String>
        allergens = (json['allergens'] as Map)
            .values
            .map((e) => e.toString())
            .toList();
      } else {
        allergens = [];
      }
    } else {
      allergens = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['keywords'] = keywords;
    data['name'] = name;
    data['image_url'] = imageUrl;
    data['ingredients'] = ingredients;
    data['allergens'] = allergens;
    return data;
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, allergens: $allergens}';
  }
}

class SearchModel {
  String? status;
  List<Products>? products;

  SearchModel({this.status, this.products});

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['products'] != null) {
      products = <Products>[];
      for (var v in json['products']) {
        try {
          products!.add(Products.fromJson(v));
        } catch (e) {
          print('Error parsing product: $e');
          print('Product data: $v');
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}