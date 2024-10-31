import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  WebSocketChannel? channel;
  List<String> messages = [];
  bool isConnected = false;
  bool isConnecting = false;

  // Konfigurasi Reverb
  final String appKey = 'u0x3cvdmybn0zpspqmo9';
  final String host = 'ciet.site';
  final String cluster = 'us2';

  @override
  void initState() {
    super.initState();
    connectToReverb();
  }

  Future<void> connectToReverb() async {
    if (isConnecting) return;

    setState(() {
      isConnecting = true;
      messages.add('Attempting to connect...');
    });

    try {
      // Format URL yang benar untuk Pusher/Reverb
      // Menggunakan format standar Pusher WebSocket
      final wsUrl = 'wss://$host/app/$appKey';

      print('Connecting to: $wsUrl'); // Debug URL

      channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['wss'],
      );

      // Listen to connection
      channel?.stream.listen(
        (dynamic message) {
          print('Received raw message: $message'); // Debug received message

          try {
            final decodedMessage = jsonDecode(message);
            handleMessage(decodedMessage);
          } catch (e) {
            print('Error decoding message: $e');
            setState(() {
              messages.add('Error decoding message: $e');
            });
          }
        },
        onError: (error) {
          print('WebSocket error: ${error}'); // Debug error
          setState(() {
            messages.add('Connection error: $error');
            isConnected = false;
            isConnecting = false;
          });
          reconnect();
        },
        onDone: () {
          print('WebSocket connection closed'); // Debug connection close
          setState(() {
            isConnected = false;
            isConnecting = false;
            messages.add('Connection closed');
          });
          reconnect();
        },
      );

      // Send connection initialization
      final connectMessage = {
        'event': 'pusher:subscribe',
        'data': {
          'channel': '7653e98a-d0ba-4de6-be98-f9558abb28b9',
        }
      };

      print(
          'Sending connection message: ${jsonEncode(connectMessage)}'); // Debug connection message
      channel?.sink.add(jsonEncode(connectMessage));

      setState(() {
        isConnected = true;
        isConnecting = false;
        messages.add('Connected successfully');
      });
    } catch (e) {
      print('Connection error: $e'); // Debug connection error
      setState(() {
        messages.add('Failed to connect: $e');
        isConnected = false;
        isConnecting = false;
      });
      reconnect();
    }
  }

  void handleMessage(Map<String, dynamic> decodedMessage) {
    print('Handling message: $decodedMessage'); // Debug message handling

    setState(() {
      if (decodedMessage['event'] == 'pusher:connection_established') {
        messages.add('Connection established!');
        isConnected = true;

        // After connection is established, subscribe to channel
        subscribeToChannel();
      } else if (decodedMessage['event'] == 'pusher:subscribe') {
        messages.add('Subscribed to channel!');
      } else {
        messages.add('Received: ${decodedMessage.toString()}');
      }
    });
  }

  void subscribeToChannel() {
    final subscribeMessage = {
      'event': 'pusher:subscribe',
      'data': {'channel': '7653e98a-d0ba-4de6-be98-f9558abb28b9'}
    };

    print(
        'Subscribing to channel: ${jsonEncode(subscribeMessage)}'); // Debug subscription
    channel?.sink.add(jsonEncode(subscribeMessage));
  }

  void reconnect() {
    if (!isConnecting && !isConnected) {
      Future.delayed(const Duration(seconds: 5), () {
        print('Attempting to reconnect...'); // Debug reconnection
        connectToReverb();
      });
    }
  }

  void sendTestMessage() {
    if (channel == null || !isConnected) {
      setState(() {
        messages.add('Cannot send message: Not connected');
      });
      return;
    }

    final message = {
      'event': 'client-message',
      'channel': '7653e98a-d0ba-4de6-be98-f9558abb28b9',
      'data': {
        'message': 'Hello from Flutter!',
        'timestamp': DateTime.now().toIso8601String(),
      }
    };

    print('Sending message: ${jsonEncode(message)}'); // Debug outgoing message
    channel?.sink.add(jsonEncode(message));

    setState(() {
      messages.add('Sent: ${message['data']}');
    });
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Reverb Demo'),
        actions: [
          Container(
            margin: const EdgeInsets.all(16.0),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected
                  ? Colors.green
                  : (isConnecting ? Colors.yellow : Colors.red),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        messages[index],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: isConnected ? null : connectToReverb,
                  child: const Text('Reconnect'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: isConnected ? sendTestMessage : null,
                      child: const Text('Send '),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivateChatDemo(
                                currentUserId:
                                    '7653e98a-d0ba-4de6-be98-f9558abb28b9',
                                otherUserId:
                                    '40bda698-b1ca-4e56-98cf-0a7f1f6191b8',
                              ),
                            ),
                          );
                        },
                        child: const Text('Private Chat'))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Utility class untuk menangani channel name
class ChatChannelUtil {
  static String createChannelName(String userId1, String userId2) {
    // Memastikan ID yang lebih kecil selalu di depan
    final sortedIds = [userId1, userId2]..sort();
    return 'chat.${sortedIds[0]}.${sortedIds[1]}';
  }
}

class PrivateChatDemo extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  const PrivateChatDemo(
      {super.key, required this.currentUserId, required this.otherUserId});

  @override
  State<PrivateChatDemo> createState() => _PrivateChatDemoState();
}

class _PrivateChatDemoState extends State<PrivateChatDemo> {
  WebSocketChannel? channel;
  List<ChatMessage> messages = [];
  bool isConnected = false;
  bool isConnecting = false;
  final TextEditingController _messageController = TextEditingController();

  // Konfigurasi Reverb
  final String appKey = 'u0x3cvdmybn0zpspqmo9';
  final String host = 'ciet.site';
  late final String channelName;

  @override
  void initState() {
    super.initState();
    // Buat channel name dengan mengurutkan ID
    channelName = ChatChannelUtil.createChannelName(
        widget.currentUserId, widget.otherUserId);
    print('Channel name: $channelName'); // Debug channel name
    connectToReverb();
  }

  Future<void> connectToReverb() async {
    if (isConnecting) return;

    setState(() {
      isConnecting = true;
      messages.add(ChatMessage(
          sender: 'System',
          message: 'Connecting to chat...',
          timestamp: DateTime.now(),
          isSystem: true));
    });

    try {
      final wsUrl = 'wss://$host/app/$appKey';
      print('Connecting to: $wsUrl');

      channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['wss'],
      );

      channel?.stream.listen(
        (dynamic message) {
          print('Received raw message: $message');
          try {
            final decodedMessage = jsonDecode(message);
            handleMessage(decodedMessage);
          } catch (e) {
            print('Error decoding message: $e');
            addSystemMessage('Error decoding message: $e');
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          addSystemMessage('Connection error: $error');
          setState(() {
            isConnected = false;
            isConnecting = false;
          });
          reconnect();
        },
        onDone: () {
          print('WebSocket connection closed');
          addSystemMessage('Connection closed');
          setState(() {
            isConnected = false;
            isConnecting = false;
          });
          reconnect();
        },
      );

      // Initial connection message
      final connectMessage = {
        'event': 'pusher:subscribe',
        'data': {
          'channel': channelName,
        }
      };

      print('Sending connection message: ${jsonEncode(connectMessage)}');
      channel?.sink.add(jsonEncode(connectMessage));
    } catch (e) {
      print('Connection error: $e');
      addSystemMessage('Failed to connect: $e');
      setState(() {
        isConnected = false;
        isConnecting = false;
      });
      reconnect();
    }
  }

void handleMessage(Map<String, dynamic> decodedMessage) {
    print('Handling message: $decodedMessage');

    setState(() {
      if (decodedMessage['event'] == 'pusher:connection_established') {
        // Perbaiki ini
        addSystemMessage('Connected successfully');
        isConnected = true;
        isConnecting = false;

        // Perbaikan format subscribe message
        final subscribeMessage = {
          'event': 'pusher:subscribe',
          'data': {
            'channel': channelName,
            'auth': null // Tambahkan ini untuk channel public
          }
        };

        channel?.sink.add(jsonEncode(subscribeMessage));
      } else if (decodedMessage['event'] == 'pusher:subscribe') {
        // Perbaiki ini
        addSystemMessage('Subscribed to chat channel');
      } else if (decodedMessage['event'] == 'chat-message' ||
          decodedMessage['event'] == 'client-message') {
        try {
          var data = decodedMessage['data'];
          if (data is String) {
            data = jsonDecode(data);
          }
          messages.add(ChatMessage(
              sender: data['sender_id'] ?? 'Unknown',
              message: data['message'] ?? 'No message',
              timestamp: DateTime.parse(
                  data['timestamp'] ?? DateTime.now().toIso8601String()),
              isSystem: false));
        } catch (e) {
          print('Error processing chat message: $e');
        }
      }
    });
  }

  // void sendMessage() {
  //   if (_messageController.text.trim().isEmpty) return;

  //   if (channel == null || !isConnected) {
  //     addSystemMessage('Cannot send message: Not connected');
  //     return;
  //   }

  //   final messageData = {
  //     'sender_id': widget.currentUserId,
  //     'message': _messageController.text.trim(),
  //     'timestamp': DateTime.now().toIso8601String(),
  //   };

  //   final message = {
  //     'event': 'chat-message', // Ubah jadi chat-message
  //     'channel': channelName,
  //     'data': jsonEncode(messageData) // Encode data sebagai string
  //   };

  //   print('Sending message: ${jsonEncode(message)}');
  //   channel?.sink.add(jsonEncode(message));

  //   // Add message to local list
  //   setState(() {
  //     messages.add(ChatMessage(
  //         sender: widget.currentUserId,
  //         message: messageData['message']!,
  //         timestamp: DateTime.parse(messageData['timestamp']!),
  //         isSystem: false));
  //   });

  //   _messageController.clear();
  // }

  void subscribeToChannel() {
    final subscribeMessage = {
      'event': 'pusher:subscribe',
      'data': {'channel': channelName}
    };

    print('Subscribing to channel: ${jsonEncode(subscribeMessage)}');
    channel?.sink.add(jsonEncode(subscribeMessage));
  }

  void addSystemMessage(String message) {
    setState(() {
      messages.add(ChatMessage(
          sender: 'System',
          message: message,
          timestamp: DateTime.now(),
          isSystem: true));
    });
  }

  void reconnect() {
    if (!isConnecting && !isConnected) {
      Future.delayed(const Duration(seconds: 5), () {
        print('Attempting to reconnect...');
        connectToReverb();
      });
    }
  }

  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    if (channel == null || !isConnected) {
      addSystemMessage('Cannot send message: Not connected');
      return;
    }

    final message = {
      'event': 'client-message',
      'channel': channelName,
      'data': jsonEncode({
        'sender_id': widget.currentUserId,
        'message': _messageController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      })
    };

    print('Sending message: ${jsonEncode(message)}');
    channel?.sink.add(jsonEncode(message));

    // Add message to local list
    setState(() {
      messages.add(ChatMessage(
          sender: widget.currentUserId,
          message: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isSystem: false));
    });

    _messageController.clear();
  }

  @override
  void dispose() {
    channel?.sink.close();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Private Chat'),
            Text(
              isConnected
                  ? 'Connected'
                  : (isConnecting ? 'Connecting...' : 'Disconnected'),
              style: TextStyle(
                fontSize: 12,
                color: isConnected
                    ? Colors.green
                    : (isConnecting ? Colors.yellow : Colors.red),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return ChatBubble(
                  message: message,
                  isCurrentUser: message.sender == widget.currentUserId,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: isConnected ? sendMessage : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isSystem;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.isSystem,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isSystem) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            message.message,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black,
              ),
            ),
            Text(
              message.timestamp.toString().substring(11, 16),
              style: TextStyle(
                fontSize: 10,
                color: isCurrentUser ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
