

import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/consultant_model.dart';
import 'package:eat_this_app/app/data/models/history_model.dart';
import 'package:eat_this_app/app/data/models/pharmacy_model.dart';
import 'package:eat_this_app/app/data/models/recommendation_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:eat_this_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  final ApiService apiService;
  

  HomeService(this.apiService);


  final Dio _dio = Dio()
    ..options = BaseOptions(
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      followRedirects: true,
      receiveTimeout: const Duration(seconds: 15),
      connectTimeout: const Duration(seconds: 15),
    );
    Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    return token;
  }


  Future<List<Products>> getRecentScans() async {
    try{
    final response = await apiService.get('product/history');
    if(response.data == null){
      throw Exception("Failed to fetch recent scans");
    }

    final productsData = response.data['products'] as List;
    print("cek data history: $productsData");
    return productsData.map((json) => Products.fromJson(json)).toList();

  } catch(e){
    throw Exception("Failed to fetch recent scans: $e");
  }
  }

   Future<List<Pharmacy>> getNearbyPharmacies(
      double latitude, double longitude) async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}pharmacy/find',
          queryParameters: {
            'user_latitude': latitude,
            'user_longitude': longitude,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Response data is null');
        }

        if (response.data['pharmacy'] == null) {
          throw Exception(
              'Pharmacy data is null. Full response: ${response.data}');
        }

        final data = response.data['pharmacy']['data'];
        if (data == null) {
          throw Exception('Pharmacy data array is null');
        }

        if (data is! List) {
          throw Exception('Expected List but got ${data.runtimeType}');
        }

        return data.map<Pharmacy>((json) => Pharmacy.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load pharmacies. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Receive timeout. Server is taking too long to respond.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e, stackTrace) {
      print('Error Stack Trace: $stackTrace');
      throw Exception('Error fetching pharmacies: $e');
    }
  }

  Future<ConsultantModel> getConsultants({String? name}) async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    print("Using token: $token");
    try {
      final response = await _dio.get("${ApiConstants.baseUrl}user/consultants",
          queryParameters: name != null ? {"name": name} : null,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      print("Response get consultant: ${response.data}");
      return ConsultantModel.fromJson(response.data);
    } catch (e) {
      print("Error get  consultant: $e");
      throw Exception(e);
    }
  }

  Future<List<ProductsRec>> getRecommendation() async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    print("Using token: $token");
    try {
      final response = await _dio.get("${ApiConstants.baseUrl}product/recommendation",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      print("Response get recommendation: ${response.data}");
      final product = response.data['products'] as List;
      print("hasil product : $product");
      return product.map((json) => ProductsRec.fromJson(json)).toList();
    } catch (e) {
      print("Error get  recommendation: $e");
      throw Exception(e);
    }
  }
}