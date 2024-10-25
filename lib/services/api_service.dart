// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/utils/dio_interceptor.dart';

class ApiService {
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    
    _dio.interceptors.add(DioInterceptor());
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            if (options?.headers != null) ...options!.headers!,
          }
          
        ),
      );

      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
                       if (options?.headers != null) ...options!.headers!,
          },
         
        ),
      );

      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return Exception('Connection timeout');
    }
    if (e.type == DioExceptionType.receiveTimeout) {
      return Exception('Unable to connect to the server');
    }
    if (e.type == DioExceptionType.unknown) {
      return Exception('Something went wrong');
    }
    
    return Exception(e.message);
  }
}