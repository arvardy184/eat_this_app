class Message {
  final String id;
  final String senderId;
  final String recipientId;
  final String message;
  final DateTime timestamp;
  final String? senderKey;
  final String? recipientKey;

  Message({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.message,
    required this.timestamp,
    this.senderKey,
    this.recipientKey,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      recipientId: json['recipient_id'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      senderKey: json['sender_key'],
      recipientKey: json['recipient_key'],
    );
  }
}