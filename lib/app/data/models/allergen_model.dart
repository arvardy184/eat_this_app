class AllergenResponse {
  final String status;
  final List<Allergen> allergens;

  AllergenResponse({
    required this.status,
    required this.allergens,
  });

  factory AllergenResponse.fromJson(Map<String, dynamic> json) {
    return AllergenResponse(
      status: json['status'],
      allergens: (json['allergens'] as List)
          .map((allergen) => Allergen.fromJson(allergen))
          .toList(),
    );
  }
}

class Allergen {
  final String name;
  final String? productKeyword;
  bool isSelected;

  Allergen({
    required this.name,
    this.productKeyword,
    this.isSelected = false,
  });

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
      name: json['name'],
      productKeyword: json['product_keyword'],
    );
  }
}
