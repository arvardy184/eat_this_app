import 'dart:async';
import 'package:eat_this_app/app/data/models/chat_user_model.dart';
import 'package:eat_this_app/app/data/models/consultant2_model.dart';
import 'package:eat_this_app/app/data/models/message_model.dart';
import 'package:eat_this_app/app/data/models/package_model.dart';
import 'package:eat_this_app/app/data/models/user2_model.dart';
import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/app/modules/chat/controllers/subscription_controller.dart';
import 'package:eat_this_app/services/chat_service.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatController extends BaseController {
  final ChatService _chatService = ChatService();
  final ApiProvider _authService = Get.put(ApiProvider());
  final SubscriptionController subsController = Get.find<SubscriptionController>();
  final RxList consultants = [].obs;
  final messages = <MessageData>[].obs;
  final RxList<ConsultantData> addedConsultants = RxList<ConsultantData>();
  final RxList<Packages> packages = RxList<Packages>();
  final RxList<Users> users = RxList<Users>(); 
  final RxList<Users> acquaintances = RxList<Users>(); 
  final RxList<Users> requests = RxList<Users>();
  final searchQuery = ''.obs;
  final isConsultant = false.obs;
  final typeUser = ''.obs;
  final isInitialized = false.obs;
   final currentUserKey = ''.obs;

  final isConnected = false.obs;
  final isConnecting = false.obs;
  bool isSubscribed = false;

  WebSocketChannel? channel;
  late final String channelName;
  final recipient = Get.arguments;

  late final String recipientKey;
  

  Future<void> init(String currentUserKey, String recipientKey) async {
    this.currentUserKey.value = currentUserKey;
    this.recipientKey = recipientKey;
    await _loadInitialData();
  }

  Future<void> loadMessages() async{
    try{
      final messagesList = await _chatService.getMessage(channelName);
      // messages.value = messagesList.reversed.toList();
       messages.assignAll(messagesList.reversed);
         print("Loaded ${messages.length} messages");
    } catch(e){
      handleError(e);
    }
  }



Future<void> sendMessage(String text) async {

  if(text.isEmpty) return;

    try {
      final optimisticMessage = MessageData(
        message: text,
        senderKey: currentUserKey.value,
        recipientKey: recipient.conversationKey,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sender: ChatUser(conversationKey: currentUserKey.value),
        recipient: ChatUser(conversationKey: recipient.conversationKey),
      );
      
      messages.insert(0, optimisticMessage);

      final success = await _chatService.sendMessage(text, recipient.conversationKey);
      if (!success) {
        messages.remove(optimisticMessage);
        Get.snackbar('Error', 'Failed to send message');
      }
    } catch (e) {
     handleError(e);
    }
  }

  


  @override
  void onInit() {
    super.onInit();
    print("chat controller init");
    checkConsultantStatus();
    initializeController();
    _initializeUserData();
  }

  




  bool canAccessChat() {
    if(isConsultant.value) return true;
    return subsController.isPremium.value;
  }

  Future<void> _initializeUserData() async {
    try {
      // Get conversation_key
      final key = await _authService.getCurrentUserKey();
      if (key != null) {
        print('User key found: $key');
        currentUserKey.value = key;
      } else {
        throw Exception('User key not found');
      }

      await checkConsultantStatus();
      if(canAccessChat()){
        await _loadInitialData();
      }
      await _loadInitialData();
    } catch (e) {
      handleError(e);
    }
  }

  void checkChatAccess(){
    if(!canAccessChat()){
      subsController.showUpgradeDialog();
    }
  }

  Future<void> initializeController() async {
    try {
      isLoading.value = true;
      await checkConsultantStatus();
      await _loadInitialData();
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
      isInitialized.value = true;
    }
  }

  Future<void> _loadInitialData() async {
    if (isConsultant.value) {
      await fetchAcquaintances();
      await fetchRequests();
    } else {
      await fetchAddedConsultants();
      await fetchConsultants();
    }
  }

  Future<void> checkConsultantStatus() async {
    try {
      final type = await _chatService.getType();
      typeUser.value = type ?? '';
      isConsultant.value = type == 'Consultant';
      print("User Type: $type, Is Consultant: ${isConsultant.value}");
    } catch (e) {
      handleError(e);
    }
  }

 Future<void> fetchConsultants({String? query}) async {
    try {
      isLoading.value = true;
      final result = await _chatService.getConsultants(name: query);
      if (result.consultants?.data != null) {
        consultants.value = result.consultants!.data!;
        if (consultants.isEmpty) {
          showError('No consultants found');
        }
      } else {
        showError('Failed to load consultants');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch added consultants
  Future<void> fetchAddedConsultants() async {
    try {
      isLoading.value = true;
      final result = await _chatService.getAddedConsultants();
      print("hasil result added: $result");
      if (result.consultants != null) {
        print("hasil 1 result addes : ${result.consultants}");
        addedConsultants.value = result.consultants!;
        print("hasil 2 result addes : $addedConsultants");
        if (addedConsultants.isEmpty) {
          // showError('No added consultants found');
          print("No added consultants found");
        }
      } else {
        showError('Failed to load added consultants');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Add consultant

Future<void> addConsultant(String consultantId) async {
  try {
    isLoading.value = true;
    

    final result = await _chatService.addConsultant(consultantId);
    
   
    addedConsultants.add(result);
    
   
    showSuccess('Consultant added successfully');
  } catch (e) {
  
    handleError(e);
  } finally {
   
    isLoading.value = false;
  }
}

Future<void> listPackage() async{
  try{
    isLoading.value = true;

    final result = await _chatService.getPackages();
    packages .value = result;

  }catch(e){
    handleError(e);
  }finally{
    isLoading.value = false;
  }
}

  // Request to become a consultant

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;
      final result = await _chatService.reqAsConsultant();
      if (result.users != null) {
        requests.assignAll(result.users!);
      } else {
        showError('Failed to load requests');
      }
    } catch (e) {
      print(" Error fetch req: $e");
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Get acquaintances
  Future<void> fetchAcquaintances() async {
    try {
      isLoading.value = true;
      final result = await _chatService.getAquaintances();
      if (result.users != null) {
        acquaintances.assignAll(
            result.users!.where((user) => user.status == 1).toList());
        requests.assignAll(
            result.users!.where((user) => user.status == 0).toList());
        // if (users.isEmpty) {
        //   showError('No acquaintances found');
        // }
      } else {
        showError('Failed to load acquaintances');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Handle acquaintance request
  Future<void> handleAcquaintanceRequest(String userId, int status) async {
    try {
      isLoading.value = true;
      final result = await _chatService.reqAnswer(userId, status);
      if (result.users == true) {
        // Check for successful response
        showSuccess(result.status ??
            (status == 1 ? 'Request accepted' : 'Request declined'));
        // Refresh lists after successful update
        await fetchAcquaintances();
        await fetchRequests();
      } else {
        showError('Failed to handle request');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Search handler
  void onSearchChanged(String query) {
    searchQuery.value = query;
    fetchConsultants(query: query);
  }

  @override
  void onClose() {
    // consultants.clear();
    // acquaintances.clear();
    // requests.clear();
    // addedConsultants.clear();
    messages.clear();
    searchQuery.value = '';
    isLoading.value = false;
    _chatService.disconnect();
    // users.clear();
    super.onClose();
  }
}
