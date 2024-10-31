class Consultant2Model {
  String? status;
  List<ConsultantData>? consultants;

  Consultant2Model({this.status, this.consultants});

  Consultant2Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['consultants'] != null) {
      consultants = <ConsultantData>[];
      json['consultants'].forEach((v) {
        consultants!.add(ConsultantData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (consultants != null) {
      data['consultants'] = consultants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConsultantData {
  String? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? profilePicture;
  String? type;
  String? specialization;
  String? almaMater;
  String? conversationKey;
  String? createdAt;
  String? updatedAt;

  ConsultantData({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.profilePicture,
    this.type,
    this.specialization,
    this.almaMater,
    this.conversationKey,
    this.createdAt,
    this.updatedAt,
  });

  ConsultantData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    profilePicture = json['profile_picture'];
    type = json['type'];
    specialization = json['specialization'];
    almaMater = json['alma_mater'];
    conversationKey = json['conversation_key'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['profile_picture'] = profilePicture;
    data['type'] = type;
    data['specialization'] = specialization;
    data['alma_mater'] = almaMater;
    data['conversation_key'] = conversationKey;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class PageLink {
  String? url;
  String? label;
  bool? active;

  PageLink({this.url, this.label, this.active});

  PageLink.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
