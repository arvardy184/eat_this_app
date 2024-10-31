import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/allergen_model.dart';
import 'package:eat_this_app/app/data/models/user_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio _dio = Dio();
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

    if (response.statusCode == 200) {
      print("res di user service ${response.data}");
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<UserModel> updateProfile(
      String? imagePath, String? name, String? birthDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found');
    }

    FormData formData = FormData();

    // Add fields conditionally
    if (name != null) {
      formData.fields.add(MapEntry('name', name));
    }

    if (birthDate != null) {
      formData.fields.add(MapEntry('birth_date', birthDate));
    }

    if (imagePath != null) {
      final file = await MultipartFile.fromFile(
        imagePath,
        filename: 'profile.jpg',
      );
      formData.files.add(MapEntry('profile_picture', file));
    }

    try {
      print("Sending data to API:");
      print("Name: $name");
      print("Birth Date: $birthDate");
      print("Image Path: $imagePath");

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

      print("API Response: ${response.data}");

      if (response.statusCode == 200) {
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
