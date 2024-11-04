import 'package:eat_this_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:eat_this_app/app/modules/chat/controllers/chat_room_controller.dart';
import 'package:eat_this_app/widgets/chats/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomPage  extends GetView<ChatRoomController>{
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final recipient = Get.arguments;

 
ChatRoomPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
 return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: _buildMessagesList()),
                _buildInputField(),
              ],
            )),
    );
  }


AppBar _buildAppBar() {
    return AppBar(
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
              Obx(() => Text(
                    controller.isConnected.value ? 'Online' : 'Connecting...',
                    style: TextStyle(
                      fontSize: 12,
                      color: controller.isConnected.value 
                          ? Colors.green 
                          : Colors.grey,
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Obx(() => ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: controller.messages.length,
          reverse: true,
          itemBuilder: (context, index) {
           final message = controller.messages[ index];
            final isCurrentUser = message.senderKey == controller.currentUserKey.value;
            print("Current user key: ${controller.currentUserKey.value} dan message sender key: ${message.senderKey}");
            return ChatBubble(
              message: message.message,
              timestamp: message.updatedAt,
              isCurrentUser: isCurrentUser,
              senderName: message.sender.name,
              senderAvatar: message.sender.profilePicture,
            );
          },
        ));
  }

   Widget _buildInputField() {
    return Container(
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
              controller: messageController,
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
          Obx(() => IconButton(
                icon: const Icon(Icons.send),
                onPressed: controller.isConnected.value 
                    ? () => _sendMessage() 
                    : null,
                color: Colors.blue,
              )),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      controller.sendMessage(messageController.text.trim());
      messageController.clear();
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
  }
}