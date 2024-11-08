import 'dart:convert';

import 'package:eat_this_app/app/data/models/chat_user_model.dart';
import 'package:eat_this_app/app/data/models/message_model.dart';
import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/app/utils/chat_channel_utils.dart';
import 'package:eat_this_app/services/chat_service.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRoomController extends BaseController {
  final ChatService _chatService = Get.find<ChatService>();
  final ApiProvider _apiService = Get.find<ApiProvider>();

  final messages = <MessageData>[].obs;
  final isConnected = false.obs;
  final isConnecting = false.obs;
  final currentUserKey = ''.obs;

  WebSocketChannel? channel;
  late final String channelName;
  final recipient = Get.arguments; // Data dari konsultan yang dipilih

  @override
  void onInit() {
    super.onInit();
    print('ChatRoomController onInit');
    _initChatRoom();
  }

  Future<void> _initChatRoom() async {
    try {
      isLoading(true);

      final key = await _apiService.getCurrentUserKey();
      if (key == null) throw Exception('No auth token available');

      currentUserKey.value = key;
      print('Current user key: $key');

      // Set channel name
      channelName = ChatChannelUtil.createChannelName(
        currentUserKey.value,
        recipient.conversationKey,
      );
      print('Channel name: $channelName');

      // Load messages
      await _loadMessages();

      // Connect WebSocket
      await connectWebSocket();
    } catch (e) {
      print('Error initializing chat room: $e');
      Get.snackbar('Error', 'Failed to initialize chat');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loadMessages() async {
    try {
      final messagesList =
          await _chatService.getMessage(recipient.conversationKey);
      messages.value = messagesList;
      print('Loaded ${messages.length} messages');
    } catch (e) {
      print('Error loading messages: $e');
      handleError(e);
    }
  }

  Future<void> connectWebSocket() async {
    if (isConnecting.value) return;

    try {
      isConnecting.value = true;
      final token = await _chatService.getToken();

      if (token == null) throw Exception('No auth token available');

      print('Connecting to WebSocket...');
      channel = await _chatService.connectWebSocket(
        channelName,
        token,
        handleWebSocketMessage,
        handleWebSocketError,
        handleWebSocketDone,
      );
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      handleWebSocketError(e);
    }
  }

  void handleWebSocketMessage(dynamic message) async {
    try {
      print("Processing WebSocket message: $message");
      final decodedMessage = jsonDecode(message);
      final event = decodedMessage['event'];
      print("Received event: $event");

      switch (event) {
        case 'pusher:connection_established':
          print("WebSocket connection established");
          var data = jsonDecode(decodedMessage['data']);
          final socketId = data['socket_id'];
          print("Socket ID: $socketId");

          final token = await _chatService.getToken();
          final auth = await _chatService.getPusherAuth(
              socketId, 'private-$channelName', token ?? '');

          if (auth != null) {
            final subscribeMessage = {
              'event': 'pusher:subscribe',
              'data': {'channel': 'private-$channelName', 'auth': auth}
            };
            channel?.sink.add(jsonEncode(subscribeMessage));
          }
          break;

        case 'pusher:subscription_succeeded':
        case 'pusher_internal:subscription_succeeded':
          print("Channel subscription succeeded");
          isConnected.value = true;
          isConnecting.value = false;
          break;

        case 'MessageSent':
          print("Got MessageSent event");
          var messageData = decodedMessage['data'];
          if (messageData is String) {
            messageData = jsonDecode(messageData);
          }

          try {
            final transformedData = {
              "sender_key": messageData['sender']['key'],
              "recipient_key": messageData['recipient']['key'],
              "message": messageData['message'],
              "created_at": messageData['sentAt'],
              "updated_at": messageData['sentAt'],
              "sender": {
                "conversation_key": messageData['sender']['key'],
                "name": messageData['sender']['name'],
                "profile_picture": messageData['sender']['profile_picture'],
              },
              "recipient": {
                "conversation_key": messageData['recipient']['key'],
                "name": messageData['recipient']['name'],
                "profile_picture": messageData['recipient']['profile_picture'],
              }
            };

            print("Transformed message data: $transformedData");
            final newMessage = MessageData.fromJson(transformedData);
            print("Created message object: $newMessage");

            if (newMessage.senderKey != currentUserKey.value) {
              messages.insert(0, newMessage); // Using RxList insert
            }
          } catch (e, stackTrace) {
            print("Error parsing message: $e");
            print("Stack trace: $stackTrace");
            print("Raw message data: $messageData");
          }
          break;

        case 'pusher:error':
          print("Pusher error: ${decodedMessage['data']}");
          final errorData = jsonDecode(decodedMessage['data']);
          print("Error code: ${errorData['code']}");
          print("Error message: ${errorData['message']}");
          break;

        default:
          print("Unhandled event: $event");
          print(
              "Full message: ${JsonEncoder.withIndent('  ').convert(decodedMessage)}");
      }
    } catch (e, stackTrace) {
      print('Error handling message: $e');
      print('Stack trace: $stackTrace');
      print('Raw message: $message');
    }
  }

  void handleWebSocketError(dynamic error) {
    print("WebSocket error: $error");
    isConnected.value = false;
    isConnecting.value = false;

    Get.snackbar('Error', 'Connection error occurred');

    // Attempt to reconnect
    Future.delayed(const Duration(seconds: 5), () {
      connectWebSocket();
    });
  }

  void handleWebSocketDone() {
    print("WebSocket connection closed");
    isConnected.value = false;
    isConnecting.value = false;

    // Attempt to reconnect
    Future.delayed(const Duration(seconds: 1), () {
      connectWebSocket();
    });
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    try {
      final optimisticMessage = MessageData(
        message: text,
        senderKey: currentUserKey.value,
        recipientKey: recipient.conversationKey,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sender: ChatUser(
          conversationKey: currentUserKey.value,
        ),
        recipient: ChatUser(
          conversationKey: recipient.conversationKey,
          name: recipient.name,
          profilePicture: recipient.profilePicture,
        ),
      );

      messages.insert(0, optimisticMessage);

      final success =
          await _chatService.sendMessage(text, recipient.conversationKey);
      if (!success) {
        messages.remove(optimisticMessage);
        Get.snackbar('Error', 'Failed to send message');
      }
    } catch (e) {
      handleError(e);
    }
  }

  @override
  void onClose() {
    print('ChatRoomController onClose');
    _chatService.disconnect();
    messages.clear();
    super.onClose();
  }
}
