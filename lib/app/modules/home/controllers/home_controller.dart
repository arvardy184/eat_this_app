import 'package:eat_this_app/app/data/models/history_model.dart';
import 'package:eat_this_app/app/data/models/recommendation_model.dart';
import 'package:eat_this_app/app/data/models/user_model.dart';
import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/app/utils/date_utils.dart';
import 'package:eat_this_app/services/api_service.dart';
import 'package:eat_this_app/services/home_service.dart';
import 'package:get/get.dart';

class HomeController extends BaseController {
  final HomeService _homeService = HomeService(ApiService());
  final ApiProvider _apiProvider = ApiProvider();

  final recentScans = <Products>[].obs;
  final isLoadingScans = false.obs;
  final isLoadingPharmacies = false.obs;
  final healthyPercentage = 0.0.obs;
  final error = Rx<String?>(null);
  final errorRecom = Rx<String?>(null);
  final userData = Rx<User?>(null);
  final recommendation = <ProductsRec>[].obs;

 
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    loadRecommendation();
    loadUserData();

      ever(recentScans, (_) {
      calculateHealthyPercentage();
      update(); // Force UI update
    });
  }

  
  Future<void> refreshData() async {
    try {
      error.value = null;
      await Future.wait([
        loadRecentScans(),
        loadRecommendation(),
        loadUserData(),
        
      ]);
    } catch (e) {
      print("Error refreshing data: $e");
      error.value = e.toString();
    }
  }


  int get todayScansCount {
    return recentScans.where((scan) {
      if (scan.pivot?.createdAt == null) return false;
      try {
        return DateUtils.isToday(scan.pivot?.createdAt);
      } catch (e) {
        print('Error counting today scans: $e');
        return false;
      }
    }).length;
  }

List<Products> get todayScans {
    final today = DateTime.now();
    return recentScans.where((scan) {
      if (scan.pivot?.createdAt == null) return false;
      try {
        final scanDate = DateTime.parse(scan.pivot!.createdAt!);
        print("cek tanggal todayscans ${scan.pivot?.createdAt} skrg ${DateTime.now().toString()} dan is utc ${scanDate.isUtc}");
        return scanDate.year == today.year &&
            scanDate.month == today.month &&
            scanDate.day == today.day;
      } catch (e) {
        print("Error parsing date: $e");
        return false;
      }
    }).toList();
}

  Future<void> loadInitialData() async {
    await loadRecentScans();
    calculateHealthyPercentage();
  }

  Future<void> loadUserData() async {
      try{
        final user = await _apiProvider.getUserData();
        if(user != null){
          userData.value = user;
          print("data user profile ${userData.value!}  ${userData.value?.name}");
        }
      } catch(e){
        print("Error load user data: $e");
        error.value = e.toString();
      }
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



Future<void> loadRecentScans() async {
    try {
      isLoadingScans(true);
      final products = await _homeService.getRecentScans();
      
      // Sort by date, newest first
      products.sort((a, b) {
        final dateA = a.pivot?.createdAt != null 
            ? DateTime.parse(a.pivot!.createdAt!) 
            : DateTime(1900);
        final dateB = b.pivot?.createdAt != null 
            ? DateTime.parse(b.pivot!.createdAt!) 
            : DateTime(1900);
        return dateB.compareTo(dateA);
      });
      
      recentScans.clear(); // Clear existing data
      recentScans.addAll(products); // Add new data

            update();

    } catch (e) {
      print("Error load recent scans: $e");
      error.value = e.toString();
    } finally {
      isLoadingScans(false);
    }
  }

   Future<void> addNewScan(Products scan) async {
    recentScans.insert(0, scan); // Add to beginning of list
    calculateHealthyPercentage();
    update();
  }


  Future<void> loadRecommendation() async{
    try{
      isLoadingPharmacies(true);
      final products = await _homeService.getRecommendation();
      recommendation.assignAll(products);
      print("hasil di home controller recommendation: $recommendation");
    }catch(e){
      print("Error load recommendation: $e");
      errorRecom.value = e.toString();
    }finally{
      isLoadingPharmacies(false);
    }
  }


}
