import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:eat_this_app/app/utils/error_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  Future<Product> fetchProductData(String barcode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}product/barcode/$barcode'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("data ${data}");
      return Product.fromJson(data);
    } else if (response.statusCode == 401) {
      await ErrorHandler.handleUnauthorized();
      throw Exception('Session expired. Please login again.');
    } else {
      throw Exception('Failed to fetch product data');
    }
  }
}