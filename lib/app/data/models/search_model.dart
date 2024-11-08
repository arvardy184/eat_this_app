class SearchModel {
  String? status;
  List<Products>? products;

  SearchModel({this.status, this.products});

  SearchModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? imageUrl;
  String? ingredients;
  List<String>? allergens;

  Products(
      {this.id,
      this.keywords,
      this.name,
      this.imageUrl,
      this.ingredients,
      this.allergens});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keywords = json['keywords'];
    name = json['name'];
    imageUrl = json['image_url'];
    ingredients = json['ingredients'];
    allergens = json['allergens'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['keywords'] = this.keywords;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['ingredients'] = this.ingredients;
    data['allergens'] = this.allergens;
    return data;
  }
}
