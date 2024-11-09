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
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
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
  String? birthDate;
  String? specialization;
  String? almamater;
  String? latitude;
  String? longitude;
  String? address;
  List<Allergens>? allergens;
  Package? package;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.profilePicture,
    this.type,
    this.conversationKey,
    this.createdAt,
    this.updatedAt,
    this.allergens,
    this.birthDate,
    this.specialization,
    this.almamater,
    this.latitude,
    this.longitude,
    this.address,
    this.package,
  });

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
    birthDate = json['birth_date'];
    specialization = json['specialization'];
    almamater = json['alma_mater'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    if (json['allergens'] != null) {
      allergens = <Allergens>[];
      json['allergens'].forEach((v) {
        allergens!.add(Allergens.fromJson(v));
      });
    }
    package =
        json['package'] != null ? Package.fromJson(json['package']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['profile_picture'] = profilePicture;
    data['type'] = type;
    data['conversation_key'] = conversationKey;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['birth_date'] = birthDate;
    data['specialization'] = specialization;
    data['alma_mater'] = almamater;
    data['latitude'] = latitude;  
    data['longitude'] = longitude;
    data['address'] = address;
    if (allergens != null) {
      data['allergens'] = allergens!.map((v) => v.toJson()).toList();
    }
    if (package != null) {
      data['package'] = package!.toJson();
    }
    return data;
  }
}

class Package {
  final int id;
  final String name;
  final int price;
  final int maxScan;
  final int maxConsultant;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Package({
    required this.id,
    required this.name,
    required this.price,
    required this.maxScan,
    required this.maxConsultant,
    this.createdAt,
    this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      maxScan: json['max_scan'],
      maxConsultant: json['max_consultant'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  bool get isPremium => name.toLowerCase() != 'free';


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['max_scan'] = maxScan;
    data['max_consultant'] = maxConsultant;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    data['name'] = name;
    data['product_keyword'] = productKeyword;
    return data;
  }
}
