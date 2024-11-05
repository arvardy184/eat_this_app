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
  final  healthyPercentage = 0.0.obs;
  final error = Rx<String?>(null);

  
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await loadRecentScans();
    calculateHealthyPercentage();
  }


  void calculateHealthyPercentage() {
    if (recentScans.isEmpty) {
      healthyPercentage.value = 0.0;
      return;
    }

    int healthyCount = 0;
    
    for (var product in recentScans) {
      final nutriscore = product.nutriscore?.toLowerCase() ?? 'unknown';
      print("Nutriscore: $nutriscore");
      if (nutriscore == 'a' || nutriscore == 'b') {
        healthyCount++;
      }
    }

    healthyPercentage.value = (healthyCount / recentScans.length) * 100;
  }



  Future<void> loadRecentScans() async{
    try{
      isLoadingScans(true);
     
     final products = await _homeService.getRecentScans();
    
        recentScans.assignAll(products);

      
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
