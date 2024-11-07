import 'package:eat_this_app/app/data/providers/api_provider.dart';

class PackageService {
  final ApiProvider apiProvider = ApiProvider();

  Future<bool> checkSubscription() async{
    try{
      final userData = await apiProvider.getUserData();

      if(userData?.user?.package == null) return false;
      final package = userData?.user?.package;
      return package?.name.toLowerCase() != 'free' ;
    } catch(e){
      print("error checking subscription: $e");
      return false;
    }
  }

  Future<int> getRemainingScans() async {
    try {
      final userData = await apiProvider.getUserData();
      if (userData?.user?.package == null) return 0;

      return userData!.user!.package!.maxScan;
    } catch (e) {
      print('Error getting remaining scans: $e');
      return 0;
    }
  }

   Future<int> getRemainingConsultations() async {
    try {
      final userData = await apiProvider.getUserData();
      if (userData?.user?.package == null) return 0;

      return userData!.user!.package!.maxConsultant;
    } catch (e) {
      print('Error getting remaining consultations: $e');
      return 0;
    }
  }
  
   String getWhatsAppLink() {
    // Ganti dengan nomor WhatsApp admin
    const adminPhone = '+6285156526353';
    const message = 'Halo, saya ingin upgrade ke Premium Package CanIEatThis?';
    
    final encodedMessage = Uri.encodeFull(message);
    return 'https://wa.me/$adminPhone?text=$encodedMessage';
  }

  

  }
