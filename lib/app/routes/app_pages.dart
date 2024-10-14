
// Import other views and bindings

// part 'app_routes.dart';

import 'package:eat_this_app/app/modules/auth/views/login_page.dart';
import 'package:eat_this_app/app/modules/home/views/home_page.dart';
import 'package:eat_this_app/app/utils/bottom_nav_bar.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: '/home',
      page: () => HomePage(),
      // binding: HomeBinding(),
    ),
    GetPage(name: '/login', page: () => LoginPage()),
   
    // tambah rute baru disini 
  ];

  
}

class Routes {
  static const HOME = '/login';
}