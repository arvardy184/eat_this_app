
class AnswerResponseModel {
  String? status;
  bool? users;

  AnswerResponseModel({
    this.status,
    this.users,
  });

  AnswerResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    users = json['users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['users'] = users;
    return data;
  }
}