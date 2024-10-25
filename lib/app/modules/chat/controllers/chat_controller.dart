import 'dart:async';

import 'package:eat_this_app/app/data/models/consultant_model.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/services/chat_service.dart';
import 'package:get/get.dart';
class ChatController extends BaseController {
  final ChatService _chatService = ChatService();
  final RxList<ConsultantData> consultants = <ConsultantData>[].obs;
  final searchQuery = ''.obs;
  // final debouncer = Debouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    fetchConsultants();
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

  void onSearchChanged(String query) {
    searchQuery.value = query;
    // debouncer.run(() => fetchConsultants(query: query));
  }

  @override
  void onClose() {
    consultants.clear();
    // debouncer.dispose();
    super.onClose();
  }
}

