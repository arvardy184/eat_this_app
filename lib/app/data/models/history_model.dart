class HistoryModel {
  String? status;
  List<Products>? products;

  HistoryModel({this.status, this.products});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['products'] != null && json['products'] is List) {
      products = [];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    } else {
      products = [];  
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (products != null && products!.isNotEmpty) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    } else {
      data['products'] = [];
    }
    return data;
  }
}

class Products {
  String? id;
  String? keywords;
  String? imageUrl;
  String? name;
  String? ingredients;
  String? quantity;
  String? nutriscore;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Products(
      {this.id,
      this.keywords,
      this.imageUrl,
      this.name,
      this.ingredients,
      this.quantity,
      this.nutriscore,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keywords = json['keywords'];
    imageUrl = json['image_url'];
    name = json['name'];
    ingredients = json['ingredients'];
    quantity = json['quantity'];
    nutriscore = json['nutriscore'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['keywords'] = keywords;
    data['image_url'] = imageUrl;
    data['name'] = name;
    data['ingredients'] = ingredients;
    data['quantity'] = quantity;
    data['nutriscore'] = nutriscore;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  String? userId;
  String? productId;
  String? createdAt;
  String? updatedAt;

  Pivot({this.userId, this.productId, this.createdAt, this.updatedAt});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['product_id'] = productId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
