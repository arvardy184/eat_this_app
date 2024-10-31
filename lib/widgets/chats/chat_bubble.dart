import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final DateTime timestamp;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentUser 
              ? Theme.of(context).primaryColor
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isCurrentUser 
                    ? Colors.white.withOpacity(0.7)
                    : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}