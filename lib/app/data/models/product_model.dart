class ProductModel {
  String? status;
  Product? product;

  ProductModel({this.status, this.product});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  String? id;
  String? keywords;
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
    this.keywords,
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
    id = json['id'];
    keywords = json['keywords'];
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
    nutrients = json['nutrients'] != null
        ? Nutrients.fromJson(json['nutrients'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['keywords'] = this.keywords;
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = this.value;
    return data;
  }
}

class Nutrients {
  int? id;
  double? serving;
  String? unit;
  double? energy;
  double? fat;
  double? saturatedFat;
  double? carbohydrate;
  double? sugar;
  double? fiber;
  double? protein;
  double? salt;
  double? alcohol;
  String? productId;

  Nutrients({
    this.id,
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
    this.productId,
  });

  Nutrients.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    serving = (json['serving'] as num?)?.toDouble(); // Konversi int ke double
    unit = json['unit'] as String?;
    energy = (json['energy'] as num?)?.toDouble();
    fat = (json['fat'] as num?)?.toDouble();
    saturatedFat = (json['saturated_fat'] as num?)?.toDouble();
    carbohydrate = (json['carbohydrate'] as num?)?.toDouble();
    sugar = (json['sugar'] as num?)?.toDouble();
    fiber = (json['fiber'] as num?)?.toDouble();
    protein = (json['protein'] as num?)?.toDouble();
    salt = (json['salt'] as num?)?.toDouble();
    alcohol = (json['alcohol'] as num?)?.toDouble();
    productId = json['product_id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
