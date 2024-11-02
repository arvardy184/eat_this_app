import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/answer_model.dart';
import 'package:eat_this_app/app/data/models/consultant2_model.dart';
import 'package:eat_this_app/app/data/models/consultant_model.dart' hide ConsultantData;
import 'package:eat_this_app/app/data/models/user2_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:get/get.dart' hide Response;
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
    final response = await dio.post(
      "${ApiConstants.baseUrl}user/consultants/add",
      data: {"consultant_id": consultantId},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    print("Request user id: $consultantId");
    print("Response add consultant: ${response.data}");
    Get.back();
    return ConsultantData.fromJson(response.data);
  } on DioException catch (dioError) {
    if (dioError.response != null) {
      // Jika server merespons dengan error
      print("Server error: ${dioError.response?.statusCode}");
      print("Error data: ${dioError.response?.data}");
      
      Get.snackbar(
        'Error',
        'Failed to add consultant: ${dioError.response?.statusMessage} (Code: ${dioError.response?.statusCode})',
      );
    } else if (dioError.type == DioExceptionType.connectionTimeout) {
      // Timeout koneksi
      print("Connection timeout occurred");
      Get.snackbar('Error', 'Connection timeout. Please try again.');
    } else if (dioError.type == DioExceptionType.receiveTimeout) {
      // Timeout penerimaan data
      print("Receive timeout occurred");
      Get.snackbar('Error', 'Receive timeout. Please try again.');
    } else if (dioError.type == DioExceptionType.unknown) {
      // Error lain seperti koneksi internet
      print("Network issue: ${dioError.message}");
      Get.snackbar('Error', 'Network issue. Please check your connection.');
    } else {
      // Error lainnya
      print("Unexpected error occurred: ${dioError.message}");
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
    throw Exception(dioError);
  } catch (e) {
    // Error lain di luar Dio
    print("Unexpected error in addConsultant: $e");
    Get.snackbar('Error', 'Failed to add consultant due to an unexpected error.');
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

Future<Response> sendMessage(String message, String recipientKey) async {
  final token = await getToken();
  if (token == null) throw Exception("Token not found");

  try {
    final response = await dio.post(
      "${ApiConstants.baseUrl}message/send",
      data: {
        "message": message,
        "recipient_key": recipientKey,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    print("Response chat: ${response.data}");
    return response;
  } on DioException catch (dioError) {
    if (dioError.response != null) {
      // The server responded with an error
      print("Server responded with an error: ${dioError.response?.statusCode}");
      print("Error data: ${dioError.response?.data}");

      Get.snackbar(
        'Error',
        'Failed to send message: ${dioError.response?.statusMessage} (Code: ${dioError.response?.statusCode})',
      );
    } else if (dioError.type == DioExceptionType.connectionTimeout) {
      // Connection timeout
      print("Connection timeout occurred");
      Get.snackbar('Error', 'Connection timeout. Please try again.');
    } else if (dioError.type == DioExceptionType.receiveTimeout) {
      // Receive timeout
      print("Receive timeout occurred");
      Get.snackbar('Error', 'Receive timeout. Please try again.');
    } else if (dioError.type == DioExceptionType.unknown) {
      // Other errors like no internet connection
      print("Network issue: ${dioError.message}");
      Get.snackbar('Error', 'Network issue. Please check your connection.');
    } else {
      // Unknown DioError
      print("Unknown error occurred: ${dioError.message}");
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
    throw Exception(dioError);
  } catch (e) {
    // Other errors (non-Dio errors)
    print("Unexpected error in sendMessage: $e");
    Get.snackbar('Error', 'Failed to send message due to an unexpected error.');
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
      print("Response chat get: ${response.data}");
      return response;
    } catch (e) {
      print("Error di getMessage: $e");
      throw Exception(e);
    }
    
}
}