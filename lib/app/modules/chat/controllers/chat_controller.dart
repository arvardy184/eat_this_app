import 'dart:async';
import 'package:eat_this_app/app/data/models/consultant_model.dart' hide ConsultantData;
import 'package:eat_this_app/app/data/models/consultant2_model.dart';
import 'package:eat_this_app/app/data/models/user2_model.dart';
import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/services/chat_service.dart';
import 'package:get/get.dart';

class ChatController extends BaseController {
  final ChatService _chatService = ChatService();
    final ApiService _authService = Get.put(ApiService());
  final RxList consultants = [].obs;
  final RxList<ConsultantData> addedConsultants = RxList<ConsultantData>();
  final RxList<Users> users = RxList<Users>();  // Changed to RxList
   final RxList<Users> acquaintances = RxList<Users>();  // For accepted users
  final RxList<Users> requests = RxList<Users>();      // For pending requests
  final searchQuery = ''.obs;
  final isConsultant = false.obs;
  final typeUser = ''.obs;
  final isInitialized = false.obs;
    final currentUserKey = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    checkConsultantStatus();
   initializeController();
   _initializeUserData();
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
      await _loadInitialData();
    } catch (e) {
      handleError(e);
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

  // Fetch all consultants with optional search
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
        addedConsultants.value = result.consultants!;
        print("hasil 2 result addes : $addedConsultants");
        if (addedConsultants.isEmpty) {
          showError('No added consultants found');
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
      if (result != null) {
        addedConsultants.add(result);
        showSuccess('Consultant added successfully');
      } else {
        showError('Failed to add consultant');
      }
    } catch (e) {
      handleError(e);
    } finally {
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
          result.users!.where((user) => user.status == 1).toList()
        );
        requests.assignAll(
          result.users!.where((user) => user.status == 0).toList()
        );
        if (users.isEmpty) {
          showError('No acquaintances found');
        }
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
      if (result.users == true) {  // Check for successful response
        showSuccess(result.status ?? (status == 1 ? 'Request accepted' : 'Request declined'));
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
    consultants.clear();
    users.clear();
    super.onClose();
  }
}