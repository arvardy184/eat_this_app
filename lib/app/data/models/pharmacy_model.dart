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
      profilePicture: json['profile_picture'],
      address: json['address'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      distance: json['distance'],
    );
  }
}

class Medicine {
  final String name;
  final String dosage;

  Medicine({
    required this.name,
    required this.dosage,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      dosage: json['dosage'],
    );
  }
}
