
import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/alternative_model.dart';
import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:eat_this_app/app/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final Dio _dio = Dio()
  ..options = BaseOptions(
    validateStatus: (status){
      return status! <= 500;
    },
    followRedirects: true,
  );

  Future<ProductModel> fetchProductData(String barcode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
   
   print("Using token: $token");
      print("Request URL: ${ApiConstants.baseUrl}product/barcode/$barcode");
    if (token == null || token.isEmpty) { 
      throw Exception('No authentication token found');
    }
   try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}product/barcode/$barcode',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      
      // Log response status and data
      print("Response status: ${response.statusCode}");
      print("Response data fetch produxt: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        print("data: ${data}");
       return ProductModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        await ErrorHandler.handleUnauthorized();
        throw Exception('Session expired. Please login again.');
      } else if(response.statusCode == 404){  
        throw Exception('Product not found');
       
      } else if(response.statusCode == 400){
          
        throw Exception("Maximum amount of product scanned reached");
      }
      else{
        throw Exception('Failed to fetch product data with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
        print('DioException: ${e.toString()}');
      print('DioError type: ${e.type}');
      print('DioError response: ${e.response?.data}');
       if (e.response?.statusCode == 401) {
        await ErrorHandler.handleUnauthorized();
        throw Exception('Session expired. Please login again.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Product not found');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Please check your internet connection.');
      } else {
        throw Exception('Failed to fetch product data: ${e.message}');
      }
    } catch (e) {
      print('General error: $e');
      throw Exception('Failed to fetch product data: $e');
    }
  }

  Future<List<Products>> getAlternative(List term) async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
   
   print("Using token: $token");
      print("Request URL: ${ApiConstants.baseUrl}product/barcode/alternative");

    if (token == null || token.isEmpty) { 
      throw Exception('No authentication token found');
    }
    if(term.isEmpty){
      throw Exception('No term found');
    }
   try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}product/alternative',
        queryParameters: {
       'term': term.join(',')
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      
      // Log response status and data
      print("Response status: ${response.statusCode}");
      print("Response data get alternative: ${response.data}");
        
      if (response.statusCode == 200) {
        final data = response.data;
        print("data: ${data}");
        final getAlternative = GetAlternativeModel.fromJson(response.data);
       return getAlternative.products ?? [];
      } else if (response.statusCode == 401) {
        if(response.data['errors']['term']){
         print("Error message di get alternative: ${response.data['errors']['term']}");

        } else{
        await ErrorHandler.handleUnauthorized();
        }
        throw Exception('Session expired. Please login again.');
      } else if(response.statusCode == 404){  
        throw Exception('Product not found');
       
      }else if(response.statusCode == 500){
        throw Exception('Failed to fetch product data with status code: ${response.statusCode}');
      }
       else{
        throw Exception('Failed to fetch product data with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
        print('DioException: ${e.toString()}');
      print('DioError type: ${e.type}');
      print('DioError response: ${e.response?.data}');
       if (e.response?.statusCode == 401) {
        await ErrorHandler.handleUnauthorized();
        throw Exception('Session expired. Please login again.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Product not found');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Please check your internet connection.');
      } else {
        throw Exception('Failed to fetch product data: ${e.message}');
      }
    } 
  }
}
