import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/user_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {

  final Dio _dio = Dio();
  Future<UserModel> getUserProfile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if(token == null || token.isEmpty){
      throw Exception('No authentication token found');
  } else{
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

  if(response.statusCode == 200){ 
    print("res di user service ${response.data}");
    return UserModel.fromJson(response.data);
  } else {
    throw Exception('Failed to fetch user profile');
  }
}

Future<void> logout () async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');

}


}