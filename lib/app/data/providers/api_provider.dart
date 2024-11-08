import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/user_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  final Dio _dio = Dio();
  static String? _accessToken;
  static String? _type;

  static const String _packageKey = 'user_package';
  static const String _scanCountKey = 'scan_count';
  static const String _consultCountKey = 'consult_count';

  ApiProvider() {
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
        final data = response.data;
        await _saveTokens(
          accessToken: data['token'] ?? '',
          refreshToken: data['refresh_token'] ?? '',
        );
        await _saveTypes(type: data['user']['type'] ?? '');
        await saveUserData(data['user'] ?? {});
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
      rethrow;
    }
  }

  Future<dynamic> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      if (refreshToken == null) {
        throw Exception('No refresh token found');
      }

      final response = await _dio.post('refresh-token',
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

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userData['id'] ?? '');
    await prefs.setString('user_name', userData['name'] ?? '');
    await prefs.setString('user_email', userData['email'] ?? '');
    await prefs.setString(
        'user_profile_picture', userData['profile_picture'] ?? '');
    await prefs.setString(
        'conversation_key', userData['conversation_key'] ?? '');
    await prefs.setString('type', userData['type'] ?? '');
    await prefs.setString(
        'user_data', json.encode(userData)); // Save complete user data
    print("Cek user data ${userData}");
    print("Cek user data yang disimpan: ${json.encode(userData)}");
  }

  Future<void> savePackageData(Package package) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_packageKey, jsonEncode(package));

    await resetCounters();
  }

  Future<void> resetCounters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final lastReset =
        DateTime.fromMillisecondsSinceEpoch(prefs.getInt(_scanCountKey) ?? 0);

    if (now.difference(lastReset).inDays >= 1) {
      await prefs.setInt(_scanCountKey, 0);
      await prefs.setInt(_consultCountKey, 0);
      await prefs.setInt('last_reset', now.millisecondsSinceEpoch);
    }
  }

  Future<User?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    print("Cek user data di get user data ${userData}");
    if (userData != null) {
      return User.fromJson(json.decode(userData));
    }
    return null;
  }

  Future<void> _saveTypes({required String type}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('type', type);

    _type = type;
    print("Cek type: ${_type}");
  }

  Future<String?> getType() async {
    final prefs = await SharedPreferences.getInstance();
    final type = prefs.getString('type');
    return type;
  }

  Future<String?> getCurrentUserKey() async {
    final prefs = await SharedPreferences.getInstance();
    final conversationKey = prefs.getString('conversation_key');
    print("cek conversation key ${conversationKey}");
    return conversationKey;
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
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('type');
    await prefs.remove('conversation_key');

    _accessToken = null;
    Get.offAllNamed('/login');
  }
}
