import 'package:dio/dio.dart';
import 'package:eat_this_app/app/data/models/history_model.dart';
import 'package:eat_this_app/app/data/models/package_model.dart';
import 'package:eat_this_app/app/data/providers/api_provider.dart';
import 'package:eat_this_app/app/utils/constant.dart';
import 'package:eat_this_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageService {

 static const String DAILY_SCAN_COUNT_KEY = 'daily_scan_count';
  static const String LAST_SCAN_DATE_KEY = 'last_scan_date';
  final ApiProvider apiProvider = ApiProvider();

  PackageService(ApiProvider find);

  final Dio dio = Dio();


  String email = '';

  Future<int> getDailyScanCount() async{
    final prefs = await SharedPreferences.getInstance();
    final lastScanDate = prefs.getString(LAST_SCAN_DATE_KEY);
    final today = DateTime.now().toIso8601String().split('T')[0];

    if(lastScanDate != today){  
      await prefs.setInt(DAILY_SCAN_COUNT_KEY, 0);
      await prefs.setString(LAST_SCAN_DATE_KEY, today);
      return 0;
    }

    return prefs.getInt(DAILY_SCAN_COUNT_KEY) ?? 0;
  }

  Future<void> incrementDailyScanCount() async{
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];

    int currrentCount = prefs.getInt(DAILY_SCAN_COUNT_KEY) ?? 0;

    await prefs.setInt(DAILY_SCAN_COUNT_KEY,currrentCount );
    await prefs.setString(LAST_SCAN_DATE_KEY, today);
  }

  Future<void> resetDailyScanCount() async{
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];

    await prefs.setInt(DAILY_SCAN_COUNT_KEY, 0);
    await prefs.setString(LAST_SCAN_DATE_KEY, today);
  }
  Future<bool> checkSubscription() async {
    try {
      final userData = await apiProvider.getUserData();
      email = userData?.email ?? '';
      if (userData?.package == null) return false;
      final package = userData?.package;
      print("package now: $package");
      return package?.name.toLowerCase() != 'free';

    } catch (e) {
      print("error checking subscription: $e");
      return false;
    }
  }

    Future<List<Products>> getRecentScans() async {
    try {
      final response = await ApiService().get('product/history');
      if (response.data == null) {
        throw Exception("Failed to fetch recent scans");
      }

      final productsData = response.data['products'] as List;
      print("cek data history di packaeg: $productsData");
      return productsData.map((json) => Products.fromJson(json)).toList();
    } catch (e) {
      print("Error get recent scans: $e");
      throw Exception("Failed to fetch recent scans: $e");
    }
  }

Future<List<Packages>> getPackages() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = await prefs.getString('auth_token');
  if (token == null) throw Exception("Token not found");
  try {
    final response = await dio.get("${ApiConstants.baseUrl}packages",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ));
    print("Response packages: ${response.data}");
    
    if (response.data['packages'] == null) {
      print("Warning: 'packages' key is null in response");
      return [];
    }
    final packages = response.data['packages'] as List;
    print("Parsed packages: $packages");

    try {
      final result = packages.map((json) => Packages.fromJson(json)).toList();
      print("Mapped packages count: ${result.length}");
      return result;
    } catch (mappingError) {
      print("Error mapping packages: $mappingError");
      throw Exception("Failed to parse package data: $mappingError");
    }

  } catch (e) {
    print("Error in getPackages: $e");
    throw Exception("Failed to fetch packages: $e");
  }
}


void _debugPrintResponse(dynamic response) {
  print("\n=== DEBUG RESPONSE ===");
  print("Response type: ${response.runtimeType}");
  print("Response data: $response");
  if (response is Map) {
    print("Available keys: ${response.keys.toList()}");
  }
  print("=====================\n");
}

  Future<int> getRemainingScans() async {
    try {
      final userData = await apiProvider.getUserData();
      email = userData?.email ?? '';
      if (userData?.package == null) return 0;
      final maxScans = userData!.package!.maxScan;
      print('Max scans: $maxScans');
      return maxScans;
    } catch (e) {
      print('Error getting remaining scans: $e');
      return 0;
    }
  }

  Future<int> getRemainingConsultations() async {
    try {
      final userData = await apiProvider.getUserData();
      if (userData?.package == null) return 0;

      email = userData?.email ?? '';
      return userData!.package!.maxConsultant;
    } catch (e) {
      print('Error getting remaining consultations: $e');
      return 0;
    }
  }

 String getWhatsAppLink() {

    // Ganti dengan nomor WhatsApp admin
    const adminPhone = '+6285156536353';
    final message = 'Halo, saya ingin upgrade ke Premium Package CanIEatThis? dengan email ${email}';

    final encodedMessage = Uri.encodeFull(message);
    return 'https://wa.me/$adminPhone?text=$encodedMessage';
  }
}
