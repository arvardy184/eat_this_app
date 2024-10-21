class ProductModel {
  String? status;
  Product? product;

  ProductModel({this.status, this.product});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  String? id;
  String? description;
  String? imageUrl;
  String? name;
  String? ingredients;
  String? quantity;
  String? nutriscore;
  String? createdAt;
  String? updatedAt;
  List<Categories>? categories;
  List<Allergens>? allergens;
  Nutrients? nutrients;

  Product({
    this.id,
    this.description,
    this.imageUrl,
    this.name,
    this.ingredients,
    this.quantity,
    this.nutriscore,
    this.createdAt,
    this.updatedAt,
    this.categories,
    this.allergens,
    this.nutrients,
  });

  Product.fromJson(Map<String, dynamic> json) {
     print("Product.fromJson called with: $json");
    id = json['id'];
    description = json['description'];
    imageUrl = json['image_url'];
    name = json['name'];
    ingredients = json['ingredients'];
    quantity = json['quantity'];
    nutriscore = json['nutriscore'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['allergens'] != null) {
      allergens = <Allergens>[];
      json['allergens'].forEach((v) {
        allergens!.add(Allergens.fromJson(v));
      });
    }
    nutrients = json['nutrients'] != null ? Nutrients.fromJson(json['nutrients']) : null;
  }

 Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    print("Product.toJson called"); // Tambahkan log ini
    data['id'] = this.id;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['name'] = this.name;
    data['ingredients'] = this.ingredients;
    data['quantity'] = this.quantity;
    data['nutriscore'] = this.nutriscore;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.allergens != null) {
      data['allergens'] = this.allergens!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.nutrients != null) {
      data['nutrients'] = this.nutrients!.toJson();
    }
    print("Product.toJson result: $data"); // Tambahkan log ini
    return data;
  }
}

class Allergens {
  String? name;
  String? productKeyword;
  String? content;

  Allergens({this.name, this.productKeyword, this.content});

  Allergens.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    productKeyword = json['product_keyword'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['product_keyword'] = this.productKeyword;
    data['content'] = this.content;
    return data;
  }
}

class Categories {
  String? value;

  Categories({this.value});

  Categories.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    return data;
  }
}

class Nutrients {
  int? id;
  int? serving;
  String? unit;
  String? energy;
  String? fat;
  double? saturatedFat;
  double? carbohydrate;
  double? sugar;
  double? fiber;
  double? protein;
  double? salt;
  String? alcohol;
  String? productId;

  Nutrients(
      {this.id,
      this.serving,
      this.unit,
      this.energy,
      this.fat,
      this.saturatedFat,
      this.carbohydrate,
      this.sugar,
      this.fiber,
      this.protein,
      this.salt,
      this.alcohol,
      this.productId});

  Nutrients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serving = json['serving'];
    unit = json['unit'];
    energy = json['energy'];
    fat = json['fat'];
    saturatedFat = json['saturated_fat'];
    carbohydrate = json['carbohydrate'];
    sugar = json['sugar'];
    fiber = json['fiber'];
    protein = json['protein'];
    salt = json['salt'];
    alcohol = json['alcohol'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serving'] = this.serving;
    data['unit'] = this.unit;
    data['energy'] = this.energy;
    data['fat'] = this.fat;
    data['saturated_fat'] = this.saturatedFat;
    data['carbohydrate'] = this.carbohydrate;
    data['sugar'] = this.sugar;
    data['fiber'] = this.fiber;
    data['protein'] = this.protein;
    data['salt'] = this.salt;
    data['alcohol'] = this.alcohol;
    data['product_id'] = this.productId;
    return data;
  }
}
