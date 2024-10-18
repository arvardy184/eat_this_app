// import 'package:dio/dio.dart';
// import 'package:can_i_eat_this/app/utils/constants.dart';
// import 'package:get/get_connect/http/src/response/response.dart';

// class ApiProvider {
//   final Dio _dio = Dio();

//   ApiProvider() {
//     _dio.options.baseUrl = API_BASE_URL;
//     // Add interceptors, headers, etc. here
//   }

//   Future<Response> get(String path) async {
//     try {
//       final response = await _dio.get(path);
//       return response;
//     } catch (e) {
//       throw e;
//     }
//   }

//   Future<Response> post(String path, dynamic data) async {
//     try {
//       final response = await _dio.post(path, data: data);
//       return response;
//     } catch (e) {
//       throw e;
//     }
//   }

//   // Add other methods (put, delete, etc.) as needed
// }
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://ciet.site/api/';

  ApiService() {
    _dio.options.baseUrl = _baseUrl;
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
