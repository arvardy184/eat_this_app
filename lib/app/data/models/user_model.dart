class UserModel {
  String? status;
  User? user;

  UserModel({this.status, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? profilePicture;
  String? type;
  String? conversationKey;
  String? createdAt;
  String? updatedAt;
  int? packageId;
  List<Allergens>? allergens;

  User(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.profilePicture,
      this.type,
      this.conversationKey,
      this.createdAt,
      this.updatedAt,
      this.packageId,
      this.allergens});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    profilePicture = json['profile_picture'];
    type = json['type'];
    conversationKey = json['conversation_key'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    packageId = json['package_id'];
    if (json['allergens'] != null) {
      allergens = <Allergens>[];
      json['allergens'].forEach((v) {
        allergens!.add(new Allergens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['profile_picture'] = this.profilePicture;
    data['type'] = this.type;
    data['conversation_key'] = this.conversationKey;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['package_id'] = this.packageId;
    if (this.allergens != null) {
      data['allergens'] = this.allergens!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Allergens {
  String? name;
  String? productKeyword;

  Allergens({this.name, this.productKeyword});

  Allergens.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    productKeyword = json['product_keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['product_keyword'] = this.productKeyword;
    return data;
  }
}
