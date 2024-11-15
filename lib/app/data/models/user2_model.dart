class User2Model {
  String? status;
  List<Users>? users;

  User2Model({this.status, this.users});

  User2Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? profilePicture;
  String? birthDate;
  String? latitude;
  String? longitude;
  String? address;
  String? type;
  String? conversationKey;
  String? lastMessage;
  String? createdAt;
  String? updatedAt;
  int? status;

  Users(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.profilePicture,
      this.birthDate,
      this.latitude,
      this.longitude,
      this.address,
      this.type,
      this.conversationKey,
      this.lastMessage,
      this.createdAt,
      this.updatedAt,
      this.status});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    profilePicture = json['profile_picture'];
    birthDate = json
    ['birth_date'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    type = json['type'];
    conversationKey = json['conversation_key'];
    lastMessage = json['last_message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['profile_picture'] = this.profilePicture;
    data['birth_date'] = this.birthDate;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['type'] = this.type;
    data['conversation_key'] = this.conversationKey;
    data['last_message'] = this.lastMessage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    return data;
  }
}
