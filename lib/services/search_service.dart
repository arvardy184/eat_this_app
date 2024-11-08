import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/search_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchService {
  final Dio _dio = Dio()
    ..options = BaseOptions(
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      followRedirects: true,
      receiveTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
    );

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    return token;
  }

  Future<List<Products>> getRecommendedProducts() async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");

    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}product/recommendation',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['products']; // Updated here
        return data.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (e) {
      throw Exception('Error fetching recommended products: $e');
    }
  }

Future<List<Products>> searchProducts(String term) async {
  final token = await getToken();
  if (token == null) throw Exception("Token not found");

  try {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}product/search',
      queryParameters: {'term': term},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    print("Response for search: $response");

    if (response.statusCode == 200) {
      if (response.data != null && response.data['products'] is List) {
        final List<dynamic> data = response.data['products'];
        print("Data fetched from search: $data");

        return data.map((json) => Products.fromJson(json)).toList();
      } else if(response.data != null && response.data['products'] is Map) {
        final Map<String, dynamic> data = response.data['products'];
        print("Data fetched from search: $data");

        return [Products.fromJson(data)];
      }
      else {
        throw Exception('Invalid data format: Expected a list of products');
      }
    } else {
      throw Exception('Failed to search products');
    }
  } catch (e) {
    throw Exception('Error searching products: $e');
  }
}

}
