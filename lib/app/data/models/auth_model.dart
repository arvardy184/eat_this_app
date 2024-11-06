class LoginResponse {
  String? status;
  User? user;
  String? token;

  LoginResponse({this.status, this.user, this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? profilePicture;
  String? birthDate;
  String? type;
  String? latitude;
  String? longitude;
  String? address;
  String? conversationKey;
  String? createdAt;
  String? updatedAt;
  int? packageId;

  User(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.profilePicture,
      this.birthDate,
      this.type,
      this.latitude,
      this.longitude,
      this.address,
      this.conversationKey,
      this.createdAt,
      this.updatedAt,
      this.packageId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    profilePicture = json['profile_picture'];
    birthDate = json['birth_date'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    conversationKey = json['conversation_key'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    packageId = json['package_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['profile_picture'] = this.profilePicture;
    data['birth_date'] = this.birthDate;
    data['type'] = this.type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['conversation_key'] = this.conversationKey;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['package_id'] = this.packageId;
    return data;
  }
}
