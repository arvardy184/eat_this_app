import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/allergen_model.dart';
import 'package:eat_this_app/app/data/models/password_model.dart';
import 'package:eat_this_app/app/data/models/user_model.dart';
import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio _dio = Dio();
  final ApiProvider _apiProvider = ApiProvider();
  Future<UserModel> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found');
    } else {
      print(" token $token");
    }

    final response = await _dio.get(
      '${ApiConstants.baseUrl}me',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    print("responset d di user service ${response.data}");

    if (response.statusCode == 200) {
      print("res di user service ${response.data}");
      await _apiProvider.saveUserData(response.data['user'] ?? {});
      return UserModel.fromJson(response.data);
    } else if (response.statusCode == 500) {
      print("res di user service ${response.data}");
      throw Exception('Failed to fetch user profile');
    } else {
      print("res di user service ${response.data}");
      throw Exception('Failed to fetch user profile');
    }
  }
Future<UserModel> updateProfile(
  String? imagePath,
  String? name,
  String? birthDate, {
  String? almaMater,
  String? specialization,
  String? address,
  double? latitude,
  double? longitude,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  if (token == null || token.isEmpty) {
    throw Exception('No authentication token found');
  }

  FormData formData = FormData();

  // Add basic fields
  if (name != null) {
    formData.fields.add(MapEntry('name', name));
  }
  if (birthDate != null) {
    formData.fields.add(MapEntry('birth_date', birthDate));
  }

  // Add consultant fields
  if (almaMater != null) {
    formData.fields.add(MapEntry('alma_mater', almaMater));
  }
  if (specialization != null) {
    formData.fields.add(MapEntry('specialization', specialization));
  }

  // Add pharmacy fields
  if (address != null) {
    formData.fields.add(MapEntry('address', address));
  }
  if (latitude != null) {
    formData.fields.add(MapEntry('latitude', latitude.toString()));
  }
  if (longitude != null) {
    formData.fields.add(MapEntry('longitude', longitude.toString()));
  }

  // Add image if provided
  if (imagePath != null) {
    final file = await MultipartFile.fromFile(
      imagePath,
      filename: 'profile.jpg',
    );
    formData.files.add(MapEntry('profile_picture', file));
  }

  try {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}user/update',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update profile');
    }
  } catch (e) {
    print("Error in updateProfile: $e");
    rethrow;
  }
}

  Future<List<Allergen>> getAllergens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found');
    }

    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}allergens',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final allergenResponse = AllergenResponse.fromJson(response.data);
        return allergenResponse.allergens;
      } else {
        throw Exception('Failed to fetch allergens');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.data}');
      throw Exception('Network error occurred');
    }
  }
Future<PasswordModel> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.post(
        '${ApiConstants.baseUrl}user/change-password',
        data: {
          'last_password': oldPassword,
          'new_password': newPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data['token'] != null) {
          // Save new token
          await prefs.setString('auth_token', response.data['token']);
      
        }
        return PasswordModel.fromJson(response.data);
      } else {
        print("Response data: ${response.data}");
        throw Exception(response.data['message'] ?? 'Failed to change password');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Current password is incorrect');
      }
      print("Dio error: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? 'Failed to change password');
    }
  }
  Future<void> updateUserAllergens(List<String> allergens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found');
    }

    final response = await _dio.post(
      '${ApiConstants.baseUrl}user/allergens',
      data: {
        'allergens': allergens,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update allergens');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('type');
  }
}
