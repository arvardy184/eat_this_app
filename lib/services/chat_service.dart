import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/answer_model.dart';
import 'package:eat_this_app/app/data/models/consultant2_model.dart';
import 'package:eat_this_app/app/data/models/consultant_model.dart' hide ConsultantData;
import 'package:eat_this_app/app/data/models/user2_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final Dio dio = Dio();

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    return token;
  }

  Future<String?> getType() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? type = preferences.getString('type');
    return type;
  }

  Future<ConsultantModel> getConsultants({String? name}) async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    print("Using token: $token");
    try {
      final response = await dio.get("${ApiConstants.baseUrl}user/consultants",
          queryParameters: name != null ? {"name": name} : null,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      print("Response get consultant: ${response.data}");
      return ConsultantModel.fromJson(response.data);
    } catch (e) {
      print("Error get  consultant: $e");
      throw Exception(e);
    }
  }

  Future<Consultant2Model> getAddedConsultants() async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response =
          await dio.get("${ApiConstants.baseUrl}user/consultants/added",
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
              ));
      print("Response get added: ${response.data}");
      return Consultant2Model.fromJson(response.data);
    } catch (e) {
      print("Error get added: $e");
      throw Exception(e);
    }
  }

  Future<ConsultantData> addConsultant(String consultantId) async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response =
          await dio.post("${ApiConstants.baseUrl}user/consultants/add",
              data: {"consultant_id": consultantId},
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
              ));
      print("Response add consultant: ${response.data}");
      return ConsultantData.fromJson(response.data);
    } catch (e) {
      print("Error di add: $e");
      throw Exception(e);
    }
  }

  Future<User2Model> reqAsConsultant() async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response =
          await dio.get("${ApiConstants.baseUrl}user/requests",
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
              ));
      print("Response req: ${response.data}");
      return User2Model.fromJson(response.data);
    } catch (e) {
      print("Error di req: $e");
      throw Exception(e);
    }
  }


  Future<User2Model> getAquaintances() async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response = await dio.get("${ApiConstants.baseUrl}user/acquaintances",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      print("Response: ${response.data}");
      return User2Model.fromJson(response.data);
    } catch (e) {
      print("Error di getAquaintances: $e");
      throw Exception(e);
    }
  }

  Future<AnswerResponseModel> reqAnswer(String userId, int status) async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response =
          await dio.post("${ApiConstants.baseUrl}user/requests/answer",
              data: {"user_id": userId, "status": status},
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
              ));
      print("Response: ${response.data}");
      return AnswerResponseModel.fromJson(response.data);
    } catch (e) {
      print("Error di reqAnswer: $e");
      throw Exception(e);
    }
  }

  Future<Response> sendMessage(String message, String recipientKey) async{
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response = await dio.post("${ApiConstants.baseUrl}message/send",
          data: {"message": message, "recipient_key": recipientKey},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      print("Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error di sendMessage: $e");
      throw Exception(e);
    }
  }

    Future<Response> getMessage(String key) async{
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response = await dio.get("${ApiConstants.baseUrl}message/retrieve?key=$key",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      print("Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error di getMessage: $e");
      throw Exception(e);
    }
      
}
}