class Pharmacy {
  final String id;
  final String name;
  final String email;
  final String profilePicture;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;

  Pharmacy({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'] ?? 'Jl. Veteran',
      profilePicture: json['profile_picture'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      distance: json['distance'],
    );
  }
}

class Medicine {
  final String id;
  final String name;
  final String content;
  final String imageUrl;

  Medicine({
    required this.id,
    required this.name,
    required this.content,
    required this.imageUrl,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'].toString(),
      name: json['name'],
      content: json['content'],
      imageUrl: json['image_url'] ?? 'Example',
    );
  }
}
