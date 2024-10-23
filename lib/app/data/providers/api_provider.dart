
import 'dart:convert';

import 'package:dio/dio.dart' ;
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  final Dio _dio = Dio();
 static String? _accessToken;
    static String? _refreshToken;

  ApiService() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    
    // _dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) async {
    //     final token = await _authStorage.getToken();
    //     if (token != null) {
    //       options.headers['Authorization'] = 'Bearer $token';
    //     }
    //     return handler.next(options);
    //   },
    // ));
  }
Future<Response> login(String email, String password) async {
  try {
    final response = await _dio.post(ApiConstants.baseUrl + 'login', data: {
      'email': email,
      'password': password,
    });

    print("Response status code: ${response.statusCode}");
    print("Response data: ${response.data}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;  // No need to decode
      await _saveTokens(
        accessToken: data['token'],  // Token field in response
        refreshToken: data['refresh_token'] ?? '',  // In case you don't have refresh_token
      );
      return response;
    } else {
      print("Login failed with status code: ${response.statusCode}");
      return response;
    }
  } catch (e) {
    print("Login error: $e");
    throw e;
  }
}



  Future<Response> signup(String name, String email, String password) async {
    try {
      final response = await _dio.post('register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      throw e;
    }
  }

   Future<dynamic> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      if (refreshToken == null) {
        throw Exception('No refresh token found');
      }

      final response = await _dio.post(
       'refresh-token',
       
         options: Options(
      headers: {
        'Authorization': 'Bearer $refreshToken',
        'Content-Type': 'application/json',
      },
         ));
    

      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        await _saveTokens(
          accessToken: data['token'],
          refreshToken: data['token'],
        );
        return data['token'];
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw e;
    }
  }

Future<void> _saveTokens({
  required String accessToken,
  String? refreshToken,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', accessToken);
  
  if (refreshToken != null) {
    await prefs.setString('refresh_token', refreshToken);
  }

  _accessToken = accessToken;
  _refreshToken = refreshToken;
}



  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    _accessToken = null;
    _refreshToken = null;
    Get.offAllNamed('/login');
  }

}

