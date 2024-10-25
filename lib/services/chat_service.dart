import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/consultant_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final Dio dio = Dio();

  Future<ConsultantModel> getConsultants({String? name}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
      print("Using token: $token");
    try{
      final response = await dio.get(
        "${ApiConstants.baseUrl}user/consultants",
        queryParameters: name != null ? {"name": name} : null,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        )
      );
      print("Response: ${response.data}");
      return ConsultantModel.fromJson(response.data);
    } catch(e){
      print("Error: $e");
      throw Exception(e);
    }
  }
}
