import 'package:eat_this_app/app/data/models/chat_user_model.dart';

class MessageResponse {
  final String status;
  final Messages messages;

  MessageResponse({required this.status, required this.messages});

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      status: json['status'],
      messages: Messages.fromJson(json['messages']),
    );
  }
}

class Messages {
  final int currentPage;
  final List<MessageData> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  Messages({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      currentPage: json['current_page'],
      data: List<MessageData>.from(json['data'].map((x) => MessageData.fromJson(x))),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List<Link>.from(json['links'].map((x) => Link.fromJson(x))),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class MessageData {
  final String senderKey;
  final String recipientKey;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ChatUser sender;
  final ChatUser recipient;

  MessageData({
    required this.senderKey,
    required this.recipientKey,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
    required this.recipient,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      senderKey: json['sender_key'],
      recipientKey: json['recipient_key'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      sender: ChatUser.fromJson(json['sender']),
      recipient: ChatUser.fromJson(json['recipient']),
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'sender_key': senderKey,
      'recipient_key': recipientKey,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sender': sender.toJson(),
      'recipient': recipient.toJson(),
    };
  }
}

class User {
  final String conversationKey;
  final String name;
  final String profilePicture;

  User({
    required this.conversationKey,
    required this.name,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      conversationKey: json['conversation_key'],
      name: json['name'],
      profilePicture: json['profile_picture'],
    );
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
