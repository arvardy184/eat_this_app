class PackageModel {
  String? status;
  List<Packages>? packages;

  PackageModel({this.status, this.packages});

  PackageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(new Packages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.packages != null) {
      data['packages'] = this.packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Packages {
  int? id;
  String? name;
  int? price;
  int? maxScan;
  int? maxConsultant;
  String? createdAt;
  String? updatedAt;

  Packages(
      {this.id,
      this.name,
      this.price,
      this.maxScan,
      this.maxConsultant,
      this.createdAt,
      this.updatedAt});

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    maxScan = json['max_scan'];
    maxConsultant = json['max_consultant'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['max_scan'] = this.maxScan;
    data['max_consultant'] = this.maxConsultant;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
