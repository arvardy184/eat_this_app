
import 'package:dio/dio.dart';
import 'package:eat_this_app/services/api_service.dart';

class ApiService {
  final Dio _dio = Dio();
 

  ApiService() {
    _dio.options.baseUrl = API_BASE_URL;
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
      final response = await _dio.post('login', data: {
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
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
}
