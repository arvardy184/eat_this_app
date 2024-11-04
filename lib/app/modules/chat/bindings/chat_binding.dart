import 'package:eat_this_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:eat_this_app/app/modules/chat/controllers/chat_room_controller.dart';
import 'package:eat_this_app/services/chat_service.dart';
import 'package:get/get.dart';


class ChatBinding  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
     Get.lazyPut<ChatRoomController>(() => ChatRoomController());
    Get.put(ChatService() );
  }
}