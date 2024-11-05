import 'package:eat_this_app/app/data/models/history_model.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/services/api_service.dart';
import 'package:eat_this_app/services/home_service.dart';
import 'package:get/get.dart';

class HomeController extends BaseController {
  final HomeService _homeService = HomeService(ApiService());

  final recentScans = <Products>[].obs;
  final isLoadingScans = false.obs;
  final isLoadingPharmacies = false.obs;
  final error = Rx<String?>(null);

  
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadInitialData() async{
    await Future.wait([
      loadRecentScans(),
      
    ]);
  }


  Future<void> loadRecentScans() async{
    try{
      isLoadingScans(true);
      final response = await _homeService.getRecentScans();

     
     final products = await _homeService.getRecentScans();
      if(products != null){
        recentScans.assignAll(products);

      }
    }catch(e){
      error.value = e.toString();
    }finally{
      isLoadingScans(false);
    }
  }

  Future<void> refreshData() async{
    error.value = null;
    await loadInitialData();
    await loadRecentScans();
  }
}
