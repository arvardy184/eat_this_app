class HistoryModel {
  String? status;
  List<Products>? products;

  HistoryModel({this.status, this.products});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
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
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['keywords'] = this.keywords;
    data['image_url'] = this.imageUrl;
    data['name'] = this.name;
    data['ingredients'] = this.ingredients;
    data['quantity'] = this.quantity;
    data['nutriscore'] = this.nutriscore;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
