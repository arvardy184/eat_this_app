
class ChatUser {
  final String conversationKey;
  final String? name;
  final String? profilePicture;

  ChatUser({
    required this.conversationKey,
    this.name,
    this.profilePicture,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      conversationKey: json['conversation_key'] ?? '',
      name: json['name'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_key': conversationKey,
      'name': name,
      'profile_picture': profilePicture,
    };
  }
}