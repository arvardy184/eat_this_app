
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // Jika token tidak ada, arahkan ke halaman login
      if (token == null || token.isEmpty) {
        return GetNavConfig.fromRoute('/login');
      }

      // Jika token valid, lanjutkan ke rute yang diminta
      return await super.redirectDelegate(route);
    } catch (e) {
      // Jika terjadi error, arahkan ke halaman login untuk berjaga-jaga
      return GetNavConfig.fromRoute('/login');
    }
  }
}
