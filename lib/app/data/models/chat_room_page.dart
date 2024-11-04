
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:eat_this_app/app/data/models/chat_model.dart';
// import 'package:eat_this_app/app/data/models/chat_user_model.dart';
// import 'package:eat_this_app/app/data/models/message_model.dart';
// import 'package:eat_this_app/app/modules/chat/controllers/chat_controller.dart';
// import 'package:eat_this_app/app/utils/chat_channel_utils.dart';
// import 'package:eat_this_app/services/chat_service.dart';
// import 'package:eat_this_app/widgets/chats/chat_bubble.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';

// class ChatRoomPages extends StatefulWidget {
//   const ChatRoomPages({super.key});

//   @override
//   State<ChatRoomPages> createState() => _ChatRoomPagesState();
// }
// class _ChatRoomPagessState extends State<ChatRoomPages> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   WebSocketChannel? channel;
//   final ChatService _chatService = Get.put(ChatService());
//   List<MessageData> messages = [];
//   bool isConnected = false;
//   bool isConnecting = false;
//   late final String channelName;
//   bool _disposed = false; // Add this flag to track disposal state
//   bool isSubscribed = false;
//   // Reverb config
//   final String appKey = 'u0x3cvdmybn0zpspqmo9';
//   final String host = 'ciet.site';
//    final int port = 443;
//   final String scheme = 'https';
//   final String cluster = 'us2';

//   // Get from arguments
//   final dynamic recipient = Get.arguments;
//   late final String currentUserKey;
//   late final String recipientKey;

//   @override
//   void initState() {
//     super.initState();
//     print(" Recipient: $recipient");
//     initChatRoom();
//   }

//   Future<void> initChatRoom() async {
//     if (_disposed) return;

//     final chatController = Get.find<ChatController>();

//     currentUserKey = chatController.currentUserKey.value;
//     print("init chat room : $currentUserKey");
//     if (currentUserKey.isEmpty) {
//       if (!_disposed) {
//         Get.snackbar('Error', 'Failed to load messages');
//         Get.back();
//       }
//       return;
//     }

//     recipientKey = recipient.conversationKey;
//     print("init chat room : $recipientKey");
//     channelName = ChatChannelUtil.createChannelName(currentUserKey, recipientKey);
//     print("Channel name: $channelName");
//     await _loadMessages();
//     if (!_disposed) {
//       connectToWebSocket();
//     }
//   }

//   Future<void> _loadMessages() async {
//     if (_disposed) return;

//     try {
//       final response = await _chatService.getMessage(recipientKey);
//       final List<dynamic> messageDataList = response.data['messages']['data'];
//       print("Message data: $messageDataList");

//       if (!_disposed) {
//         setState(() {
//        messages = messageDataList
//               .map((message) => MessageData.fromJson(message))
//               .toList()
           
//               .toList();
//           print("Messages: $messages");
//         });
//         _scrollToBottom();
//       }
//     } catch (e) {
//       print('Error loading messages: $e');
//       if (!_disposed) {
//         Get.snackbar('Error', 'Failed to load messages: $e');
//       }
//     }
//   }


// Future<String?> getPusherAuthSignature(String socketId, String channelName) async {
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//       print("$socketId, $channelName, $token");
//     final response = await Dio().post(
//       'https://ciet.site/api/pusher/auth',
//       data: {
//         'socket_id': socketId,
//         'channel_name': channelName,
//       },
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ),
//     );

//     print("Response Pusher auth: ${response.data}");
//   final responseData = response.data is String ? jsonDecode(response.data) : response.data;

//      if (response.statusCode == 200 && responseData['auth'] != null) {
//       String auth = responseData['auth'];
//       print("Got Pusher auth signature: $auth");
//       return auth;
//     }
//     return null;
//   } catch (e) {
//     print("Error getting Pusher auth: $e");
//     return null;
//   }
// }



// Future<void> connectToWebSocket() async {
//     if (_disposed || isConnecting) return;

//     if (!mounted) return;
//     setState(() {
//       isConnecting = true;
//     });

//     try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         final token = prefs.getString('auth_token');
//         print("Using token for connection: $token");

        
//        final wsUrl ='wss://$host:$port/app/$appKey';
//         print("Connecting to WebSocket: $wsUrl");

//         // Headers sesuai dengan Pusher
//         final Map<String, dynamic> headers = {
//            'Authorization': 'Bearer $token',
//             'cluster': cluster,
//             'useTLS': 'true',
//             'version': '7.0',
//             'client': 'dart',
//         };

//         final socket = await WebSocket.connect(
//           wsUrl,
//           protocols: ['ws', 'wss'],
//           headers: headers,
//         );

//         channel = IOWebSocketChannel(socket);

//         channel?.stream.listen(
//           (message) {
//             print("WebSocket message received: $message");
//             if (!_disposed) {
//               handleWebSocketMessage(message);
//             }
//           },
//           onError: (error) {
//             print("WebSocket error: $error");
//             if (!_disposed) {
//               handleWebSocketError(error);
//             }
//           },
//           onDone: () {
//             print("WebSocket connection closed");
//             if (!_disposed) {
//               handleWebSocketDone();
//             }
//           },
//           cancelOnError: true,
//         );

//     } catch (e) {
//       print("WebSocket connection error: $e");
//       if (!_disposed) {
//         handleWebSocketError(e);
//       }
//     }
// }
//  void _addNewMessage(MessageData message) {
//     setState(() {
//       // Insert di awal list untuk menambah pesan terbaru
//       messages.insert(0, message);
//     });
    
//     // Scroll ke atas karena ListView di-reverse
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           0, // Scroll ke atas karena pesan terbaru di awal list
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
// }

  

// Future<void> sendMessage() async {
//     final messageText = _messageController.text.trim();
//     if (messageText.isEmpty) return;

//     try {
//       _messageController.clear();

//       final optimisticMessage = MessageData(
//         message: messageText,
//         senderKey: currentUserKey,
//         recipientKey: recipientKey,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         sender: ChatUser(conversationKey: currentUserKey),
//         recipient: ChatUser(conversationKey: recipientKey),
//       );
      
//       _addNewMessage(optimisticMessage);

//       final response = await _chatService.sendMessage(
//         messageText,
//         recipientKey,
//       );

//       print("Message sent response data: ${response.data}");

//       if (response.data['status'] != 'Message sent') {
//         Get.snackbar('Error', 'Failed to send message');
//         // Remove optimistic message if failed
//         setState(() {
//           messages.remove(optimisticMessage);
//         });
//       }
//     } catch (e) {
//       print("Error in sendMessage: $e");
//       Get.snackbar('Error', 'Failed to send message: ${e.toString()}');
//     }
//   }


// void handleWebSocketMessage(dynamic message) async {
//     if (_disposed) return;
//     try {
//       print("Processing WebSocket message: $message");
//       final decodedMessage = jsonDecode(message);
//       final event = decodedMessage['event'];
//       print("Received event: $event");

//       switch (event) {
//         case 'pusher:connection_established':
//           print("WebSocket connection established");
//           var data = jsonDecode(decodedMessage['data']);
//           final socketId = data['socket_id'];
//           print("Socket ID: $socketId");

//           final auth = await getPusherAuthSignature(socketId, 'private-$channelName');
          
//           if (auth != null) {
//             print("Got auth signature, subscribing to channel...");
//             final subscribeMessage = {
//               'event': 'pusher:subscribe',
//               'data': {
//                 'channel': 'private-$channelName',
//                 'auth': auth
//               }
//             };
//             channel?.sink.add(jsonEncode(subscribeMessage));
//           }
//           break;

//         case 'pusher:subscription_succeeded':
//         case 'pusher_internal:subscription_succeeded':
//           print("Channel subscription succeeded");
//           setState(() {
//             isConnected = true;
//             isConnecting = false;
//             isSubscribed = true;
//           });
//           break;

//         case 'MessageSent':
//           print("Got MessageSent event");
//           var messageData = decodedMessage['data'];
//           if (messageData is String) {
//             messageData = jsonDecode(messageData);
//           }
          
//           try {
//             // Konversi format message ke format yang sesuai dengan MessageData
//             final transformedData = {
//               "sender_key": messageData['sender']['key'],
//               "recipient_key": messageData['recipient']['key'],
//               "message": messageData['message'],
//               "created_at": messageData['sentAt'],
//               "updated_at": messageData['sentAt'],
//               "sender": {
//                 "conversation_key": messageData['sender']['key'],
//                 "name": messageData['sender']['name'],
//                 "profile_picture": messageData['sender']['profile_picture'],
//               },
//               "recipient": {
//                 "conversation_key": messageData['recipient']['key'],
//                 "name": messageData['recipient']['name'],
//                 "profile_picture": messageData['recipient']['profile_picture'],
//               }
//             };

//             print("Transformed message data: $transformedData");
//             final newMessage = MessageData.fromJson(transformedData);
//             print("Created message object: $newMessage");

//             if (newMessage.senderKey != currentUserKey) {
//               if (!mounted) return;
//               _addNewMessage(newMessage);
//             }
//           } catch (e, stackTrace) {
//             print("Error parsing message: $e");
//             print("Stack trace: $stackTrace");
//             print("Raw message data: $messageData");
//           }
//           break;

//         case 'pusher:error':
//           print("Pusher error: ${decodedMessage['data']}");
//           final errorData = jsonDecode(decodedMessage['data']);
//           print("Error code: ${errorData['code']}");
//           print("Error message: ${errorData['message']}");
//           break;

//         default:
//           print("Unhandled event: $event");
//           print("Full message: ${JsonEncoder.withIndent('  ').convert(decodedMessage)}");
//       }
//     } catch (e, stackTrace) {
//       print('Error handling message: $e');
//       print('Stack trace: $stackTrace');
//       print('Raw message: $message');
//     }
// }
//   void handleWebSocketError(dynamic error) {
//     if (_disposed) return;

//     if (!mounted) return; // Check mounted before setState
//     setState(() {
//       isConnected = false;
//       isConnecting = false;
//     });
    
//     if (!_disposed) {
//       Get.snackbar('Error', 'Connection error occurred');
//       // Use a canceled variable to prevent reconnection after disposal
//       Future.delayed(const Duration(seconds: 5), () {
//         if (!_disposed) {
//           connectToWebSocket();
//         }
//       });
//     }
//   }

//   void handleWebSocketDone() {
//     if (_disposed) return;

//     if (!mounted) return; // Check mounted before setState
//     setState(() {
//       isConnected = false;
//       isConnecting = false;
//     });
    
//     if (!_disposed) {
//       Future.delayed(const Duration(seconds: 1), () {
//         if (!_disposed) {
//           connectToWebSocket();
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//      print("Disposing ChatRoomPages"); // Debug disposal
//     _disposed = true; // Set disposal flag
//     // if (isSubscribed) {
//     //   final unsubscribeMessage = {
//     //     'event': 'pusher:unsubscribe',
//     //     'data': {
//     //       'channel': 'private-$channelName'
//     //     }
//     //   };
//     //   channel?.sink.add(jsonEncode(unsubscribeMessage));
//     // }
//     channel?.sink.close();
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//    void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         0.0, // Scroll ke 0 karena ListView di-reverse
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: recipient.profilePicture != null
//                   ? NetworkImage(recipient.profilePicture!)
//                   : null,
//               child: recipient.profilePicture == null
//                   ? Text(recipient.name![0])
//                   : null,
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(recipient.name ?? 'Unknown'),
//                 Text(
//                   isConnected ? 'Online' : 'Connecting...',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: isConnected ? Colors.green : Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               cacheExtent: 1000,
//               controller: _scrollController,
//               padding: const EdgeInsets.all(8),
//               itemCount: messages.length,
//               reverse: true,
//               itemBuilder: (context, index) {s
//                 final message = messages[index];
//                 final isCurrentUser = message.senderKey == currentUserKey;
//                 print("isCurrentUser: $isCurrentUser");
//                 print("messageapa: $message");
//                 return ChatBubble(
//                   message: message.message,
//                   timestamp: message.updatedAt,
//                   isCurrentUser: isCurrentUser,
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   blurRadius: 4,
//                   offset: const Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                     ),
//                     maxLines: null,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: isConnected ? sendMessage : null,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }