import 'package:eat_this_app/app/data/models/consultant_model.dart';
import 'package:eat_this_app/services/chat_service.dart';
import 'package:get/get.dart';

class ChatController  extends GetxController{
  final ChatService chatService = ChatService();
  final RxList<ConsultantData> consultants = <ConsultantData>[].obs;
  final RxBool isLoading = false.obs;
  final searchQuery = ''.obs;


  @override
  void onInit() {
    super.onInit();
    fetchConsultants();
  }


  Future<void> fetchConsultants({String? query}) async {
    try{
      isLoading.value = true;
      final result = await chatService.getConsultants(name: query);
      consultants.value = result.consultants!.data!;

    } catch(e){
      print(e);
    } finally{
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query){
    searchQuery.value = query;
    fetchConsultants(query: query);
  }
}