
import 'package:eat_this_app/app/data/models/chat_model.dart';
import 'package:eat_this_app/app/data/models/message_model.dart';
import 'package:eat_this_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:eat_this_app/app/utils/chat_channel_utils.dart';
import 'package:eat_this_app/services/chat_service.dart';
import 'package:eat_this_app/widgets/chats/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}
class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  WebSocketChannel? channel;
  final ChatService _chatService = Get.put(ChatService());
  List<MessageData> messages = [];
  bool isConnected = false;
  bool isConnecting = false;
  late final String channelName;
  bool _disposed = false; // Add this flag to track disposal state

  // Reverb config
  final String appKey = 'u0x3cvdmybn0zpspqmo9';
  final String host = 'ciet.site';

  // Get from arguments
  final dynamic recipient = Get.arguments;
  late final String currentUserKey;
  late final String recipientKey;

  @override
  void initState() {
    super.initState();
    print(" Recipient: $recipient");
    initChatRoom();
  }

  Future<void> initChatRoom() async {
    if (_disposed) return;

    final chatController = Get.find<ChatController>();

    currentUserKey = chatController.currentUserKey.value;
    print("init chat room : $currentUserKey");
    if (currentUserKey.isEmpty) {
      if (!_disposed) {
        Get.snackbar('Error', 'Failed to load messages');
        Get.back();
      }
      return;
    }

    recipientKey = recipient.conversationKey;
    print("init chat room : $recipientKey");
    channelName = ChatChannelUtil.createChannelName(currentUserKey, recipientKey);
    print("Channel name: $channelName");
    await _loadMessages();
    if (!_disposed) {
      connectToWebSocket();
    }
  }

  Future<void> _loadMessages() async {
    if (_disposed) return;

    try {
      final response = await _chatService.getMessage(recipientKey);
      final List<dynamic> messageDataList = response.data['messages']['data'];
      print("Message data: $messageDataList");

      if (!_disposed) {
        setState(() {
          messages = messageDataList.map((message) => MessageData.fromJson(message)).toList();
          print("Messages: $messages");
        });
        _scrollToBottom();
      }
    } catch (e) {
      print('Error loading messages: $e');
      if (!_disposed) {
        Get.snackbar('Error', 'Failed to load messages: $e');
      }
    }
  }

  Future<void> connectToWebSocket() async {
    if (_disposed || isConnecting) return;

    if (!mounted) return; // Additional mounted check before setState
    setState(() {
      isConnecting = true;
    });

    try {
      final wsUrl = 'wss://$host/app/$appKey';
        print("Connecting to WebSocket: $wsUrl"); // Debug WebSocket connection
      channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['wss'],
      );

      channel?.stream.listen(
        (message) {
           print("WebSocket message received: $message");
          if (!_disposed) {
            handleWebSocketMessage(message);
          }
        },
        onError: (error) {
           print("WebSocket error: $error"); 
          if (!_disposed) {
            handleWebSocketError(error);
          }
        },
        onDone: () {
          print("WebSocket connection closed");
          if (!_disposed) {
            handleWebSocketDone();
          }
        },
        cancelOnError: true,
      );

      final subscribeMessage = {
        'event': 'pusher:subscribe',
        'data': {
          'channel': channelName,
       //   'auth': null
        }
      };

      channel?.sink.add(jsonEncode(subscribeMessage));
      
      if (!mounted) return; // Check mounted before setState
      setState(() {
        isConnected = true;
        isConnecting = false;
      });
    } catch (e) {
      if (!_disposed) {
        handleWebSocketError(e);
      }
    }
  }

  

Future<void> sendMessage() async {
  if (_messageController.text.trim().isEmpty) return;

  try {
    await _chatService.sendMessage(
      _messageController.text.trim(),
      recipientKey,
    );
    _messageController.clear();
  } catch (e) {
    print("Error in sendMessage: $e");
    Get.snackbar('Error', 'Failed to send message: ${e.toString()}');
  }
}


  void handleWebSocketMessage(dynamic message) {
    if (_disposed) return;

    try {
      print("Processing WebSocket message: $message"); 
      final decodedMessage = jsonDecode(message);
      if (decodedMessage['event'] == 'chat-message') {
        var data = decodedMessage['data'];
        if (data is String) {
          data = jsonDecode(data);
        }
        final newMessage = MessageData.fromJson(data);
        
        if (!mounted) return; // Check mounted before setState
        setState(() {
          messages.add(newMessage);
        });
        _scrollToBottom();
      }
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  void handleWebSocketError(dynamic error) {
    if (_disposed) return;

    if (!mounted) return; // Check mounted before setState
    setState(() {
      isConnected = false;
      isConnecting = false;
    });
    
    if (!_disposed) {
      Get.snackbar('Error', 'Connection error occurred');
      // Use a canceled variable to prevent reconnection after disposal
      Future.delayed(const Duration(seconds: 5), () {
        if (!_disposed) {
          connectToWebSocket();
        }
      });
    }
  }

  void handleWebSocketDone() {
    if (_disposed) return;

    if (!mounted) return; // Check mounted before setState
    setState(() {
      isConnected = false;
      isConnecting = false;
    });
    
    if (!_disposed) {
      Future.delayed(const Duration(seconds: 1), () {
        if (!_disposed) {
          connectToWebSocket();
        }
      });
    }
  }

  @override
  void dispose() {
    _disposed = true; // Set disposal flag
    channel?.sink.close();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

    void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: recipient.profilePicture != null
                  ? NetworkImage(recipient.profilePicture!)
                  : null,
              child: recipient.profilePicture == null
                  ? Text(recipient.name![0])
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipient.name ?? 'Unknown'),
                Text(
                  isConnected ? 'Online' : 'Connecting...',
                  style: TextStyle(
                    fontSize: 12,
                    color: isConnected ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                index = messages.length - index - 1;
                final message = messages[index];
                final isCurrentUser = message.senderKey == currentUserKey;
                print("isCurrentUser: $isCurrentUser");
                print("messageapa: $message");
                return ChatBubble(
                  message: message.message,
                  timestamp: message.updatedAt,
                  isCurrentUser: isCurrentUser,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: isConnected ? sendMessage : null,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}