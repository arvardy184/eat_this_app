import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:eat_this_app/app/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final Dio _dio = Dio(); 

  Future<Product> fetchProductData(String barcode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found');
    }

    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}product/barcode/$barcode.json',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("data ${data}");
        return Product.fromJson(data);
      } else if (response.statusCode == 401) {
        await ErrorHandler.handleUnauthorized();
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Failed to fetch product data');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await ErrorHandler.handleUnauthorized();
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Failed to fetch product data: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
