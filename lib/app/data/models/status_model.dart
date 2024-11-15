class StatusModel {
  String? status;

 StatusModel({
    this.status,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      status: json['status'] as String?,
    );
  }
}