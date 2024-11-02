import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/pharmacy_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyService {
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

  Future<List<Medicine>> getPharmacyMedicines(String pharmacyId) async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response =
          await _dio.get('${ApiConstants.baseUrl}pharmacy/medicines',
              queryParameters: {
                'pharmacy_id': pharmacyId,
              },
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
              ));
      print(response.data);
      if (response.statusCode == 200) {
        final data = response.data['medicines']['data'];
        return data.map<Medicine>((json) => Medicine.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load medicines');
      }
    } catch (e) {
      throw Exception('Error fetching medicines: $e');
    }
  }
}
