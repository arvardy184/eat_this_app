import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/answer_model.dart';
import 'package:eat_this_app/app/data/models/consultant2_model.dart';
import 'package:eat_this_app/app/data/models/consultant_model.dart'
    hide ConsultantData;
import 'package:eat_this_app/app/data/models/message_model.dart';
import 'package:eat_this_app/app/data/models/package_model.dart';
import 'package:eat_this_app/app/data/models/user2_model.dart';
import 'package:eat_this_app/app/data/models/user_model.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  final Dio dio = Dio();
  WebSocketChannel? channel;

  final String appKey = 'u0x3cvdmybn0zpspqmo9';
  final String host = 'ciet.site';
  final int port = 443;
  final String cluster = 'us2';

  bool isConnected = false;
  bool isConnecting = false;
  bool isSubscribed = false;

  Future<WebSocketChannel?> connectWebSocket(
      String channelName,
      String token,
      Function(dynamic) onMessage,
      Function(dynamic) onError,
      Function() onDone) async {
    if (isConnecting) return null;
    isConnecting = true;

    try {
      final wsUrl = "wss://$host:$port/app/$appKey";
      print("Connect to WebSocket: $wsUrl");

      final webSocket = await WebSocket.connect(wsUrl, protocols: [
        'ws',
        'wss'
      ], headers: {
        'Authorization': 'Bearer $token',
        'cluster': cluster,
        'useTLS': 'true',
        'version': '7.0',
        'client': 'dart',
      });

      channel = IOWebSocketChannel(webSocket);

      channel?.stream.listen(onMessage,
          onError: onError, onDone: onDone, cancelOnError: true);

      isConnecting = false;
      isConnected = true;
      return channel;
    } catch (e) {
      print("WebSocket connection error : $e");
      isConnecting = false;
      isConnected = false;
      throw e;
    }
  }

  Future<String?> getPusherAuth(
      String socketId, String channelName, String token) async {
    try {
      final response = await dio.post('https://$host/api/pusher/auth',
          data: {
            'socket_id': socketId,
            'channel_name': channelName,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));

      final responseData =
          response.data is String ? jsonDecode(response.data) : response.data;
      if (response.statusCode == 200 && responseData['auth'] != null) {
        String auth = responseData['auth'];
        print("Got Pusher auth signature: $auth");
        return auth;
      }
      return null;
    } catch (e) {
      print("Error di getPusherAuth: $e");
      throw e;
    }
  }

  void disconnect() {
    channel?.sink.close();
    isConnected = false;
    isSubscribed = false;
  }

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    return token;
  }

  Future<String?> getType() async {
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

   
      if (response.statusCode == 200 && response.data != null) {
        //TODO handle response add success
        return ConsultantData.fromJson(response.data);
      } else {
        throw Exception("Failed to add consultant, invalid response data");
      }
    } on DioException catch (dioError) {
   
      if (dioError.response != null) {
        print("Server error: ${dioError.response?.statusCode}");
        print("Error data: ${dioError.response?.data}");
        Get.snackbar(
          'Error',
          'Failed to add consultant: ${dioError.response?.statusMessage} (Code: ${dioError.response?.statusCode})',
        );
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
        print("Connection timeout occurred");
        Get.snackbar('Error', 'Connection timeout. Please try again.');
      } else if (dioError.type == DioExceptionType.receiveTimeout) {
        print("Receive timeout occurred");
        Get.snackbar('Error', 'Receive timeout. Please try again.');
      } else if (dioError.type == DioExceptionType.unknown) {
        print("Network issue: ${dioError.message}");
        Get.snackbar('Error', 'Network issue. Please check your connection.');
      } else {
        print("Unexpected error occurred: ${dioError.message}");
        Get.snackbar('Error', 'An unexpected error occurred.');
      }
      throw Exception(dioError);
    } catch (e) {
      print("Unexpected error in addConsultant: $e");
      Get.snackbar(
          'Error', 'Failed to add consultant due to an unexpected error.');
      throw Exception(e);
    }
  }

  Future<User2Model> reqAsConsultant() async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response = await dio.get("${ApiConstants.baseUrl}user/requests",
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
      final response =
          await dio.get("${ApiConstants.baseUrl}user/acquaintances",
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

  Future<bool> sendMessage(String message, String recipientKey) async {
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
      return response.data['status'] == 'Message sent';
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print(
            "Server responded with an error: ${dioError.response?.statusCode}");
        print("Error data: ${dioError.response?.data}");

        Get.snackbar(
          'Error',
          'Failed to send message: ${dioError.response?.statusMessage} (Code: ${dioError.response?.statusCode})',
        );
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
    
        print("Connection timeout occurred");
        Get.snackbar('Error', 'Connection timeout. Please try again.');
      } else if (dioError.type == DioExceptionType.receiveTimeout) {
   
        print("Receive timeout occurred");
        Get.snackbar('Error', 'Receive timeout. Please try again.');
      } else if (dioError.type == DioExceptionType.unknown) {
  
        print("Network issue: ${dioError.message}");
        Get.snackbar('Error', 'Network issue. Please check your connection.');
      } else {
    
        print("Unknown error occurred: ${dioError.message}");
        Get.snackbar('Error', 'An unexpected error occurred.');
      }
      throw Exception(dioError);
    } catch (e) {

      print("Unexpected error in sendMessage: $e");
      Get.snackbar(
          'Error', 'Failed to send message due to an unexpected error.');
      throw Exception(e);
    }
  }

  Future<List<MessageData>> getMessage(String recipientKey) async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response = await dio.get("${ApiConstants.baseUrl}message/retrieve",
          queryParameters: {"key": recipientKey},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));

      print("Response chat get: ${response.data}");
      final List<dynamic> messageDataList = response.data['messages']['data'];
      return messageDataList
          .map((message) => MessageData.fromJson(message))
          .toList()
          .toList();
    } catch (e) {
      print("Error di getMessage: $e");
      throw Exception(e);
    }
  }

  Future<List<Packages>> getPackages() async {
    final token = await getToken();
    if (token == null) throw Exception("Token not found");
    try {
      final response = await dio.get("${ApiConstants.baseUrl}packages",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      print("Response chat get service chat: ${response.data}");
      final package = response.data['package'] as List;
      print("Package: $package");
      return package.map((json) => Packages.fromJson(json)).toList();
    } catch (e) {
      print("Error di getPackages chat : $e");
      throw Exception(e);
    }
  }
}
