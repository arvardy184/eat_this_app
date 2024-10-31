import 'package:eat_this_app/app/data/models/chat_model.dart';
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
  List<Message> messages = [];
  bool isConnected = false;
  bool isConnecting = false;
  late final String channelName;

  // Reverb config
  final String appKey = 'u0x3cvdmybn0zpspqmo9';
  final String host = 'ciet.site';

  // Get from arguments
  late final dynamic recipient;
  late final String currentUserKey;
  late final String recipientKey;

  @override
  void initState() {
    super.initState();
    recipient = Get.arguments;
    // Get current user key from shared preferences or service
    initChatRoom();
  }

  Future<void> initChatRoom() async{
    final chatController = Get.find<ChatController>();

    currentUserKey = chatController.currentUserKey.value;
    if(currentUserKey.isEmpty){
      Get.snackbar('Error', 'Failed to load messages');
      Get.back();
      return;
    }


    recipient = Get.arguments;
    recipientKey = recipient.conversationKey;

    channelName = ChatChannelUtil.createChannelName(currentUserKey, recipientKey);

    await _loadMessages();
    connectToWebSocket();
  }

  Future<void> _loadMessages() async {
    try {
      final response = await Get.find<ChatService>().getMessage(recipientKey);
      final List<dynamic> messageData = response.data['messages'];
      setState(() {
        messages = messageData.map((m) => Message.fromJson(m)).toList();
      });
      _scrollToBottom();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages');
    }
  }

  Future<void> connectToWebSocket() async {
    if (isConnecting) return;

    setState(() {
      isConnecting = true;
    });

    try {
      final wsUrl = 'wss://$host/app/$appKey';
      channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['wss'],
      );

      channel?.stream.listen(
        (message) => handleWebSocketMessage(message),
        onError: handleWebSocketError,
        onDone: handleWebSocketDone,
      );

      // Subscribe to private channel
      final subscribeMessage = {
        'event': 'pusher:subscribe',
        'data': {
          'channel': channelName,
          'auth': null // For public channels
        }
      };

      channel?.sink.add(jsonEncode(subscribeMessage));
      setState(() {
        isConnected = true;
        isConnecting = false;
      });
    } catch (e) {
      handleWebSocketError(e);
    }
  }

  void handleWebSocketMessage(dynamic message) {
    try {
      final decodedMessage = jsonDecode(message);
      if (decodedMessage['event'] == 'chat-message') {
        var data = decodedMessage['data'];
        if (data is String) {
          data = jsonDecode(data);
        }
        final newMessage = Message.fromJson(data);
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
    setState(() {
      isConnected = false;
      isConnecting = false;
    });
    Get.snackbar('Error', 'Connection error occurred');
    Future.delayed(const Duration(seconds: 5), connectToWebSocket);
  }

  void handleWebSocketDone() {
    setState(() {
      isConnected = false;
      isConnecting = false;
    });
    Future.delayed(const Duration(seconds: 5), connectToWebSocket);
  }

  Future<void> sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await Get.find<ChatService>().sendMessage(
        _messageController.text.trim(),
        recipientKey,
      );
      _messageController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    }
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
  void dispose() {
    channel?.sink.close();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                final message = messages[index];
                final isCurrentUser = message.senderKey == currentUserKey;
                
                return ChatBubble(
                  message: message.message,
                  timestamp: message.timestamp,
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