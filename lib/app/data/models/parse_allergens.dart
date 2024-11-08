
// Helper functions untuk parsing dan validasi
class ProductHelper {
  static List<String>? parseAllergens(dynamic allergensData) {
    try {
      if (allergensData == null) return [];

      if (allergensData is List) {
        return List<String>.from(allergensData);
      }

      if (allergensData is Map) {
        return allergensData.values.map((e) => e.toString()).toList();
      }

      if (allergensData is String) {
        return allergensData.split(',').map((e) => e.trim()).toList();
      }

      print('Unknown allergens format: ${allergensData.runtimeType}');
      return [];
    } catch (e) {
      print('Error parsing allergens: $e');
      print('Allergens data: $allergensData');
      return [];
    }
  }

  static void debugPrintProduct(Map<String, dynamic> json) {
    print('\n=== Product Debug Info ===');
    print('ID: ${json['id']}');
    print('Name: ${json['name']}');
    print('Allergens type: ${json['allergens']?.runtimeType}');
    print('Allergens data: ${json['allergens']}');
    print('========================\n');
  }

  static bool isValidProduct(Map<String, dynamic> json) {
    return json.containsKey('id') && 
           json.containsKey('name') && 
           json.containsKey('allergens');
  }
}

// Gunakan dalam Products.fromJson:
