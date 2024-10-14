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