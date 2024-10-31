// Import other views and bindings

// part 'app_routes.dart';

import 'package:eat_this_app/app/middleware/auth_middleware.dart';
import 'package:eat_this_app/app/modules/auth/views/forgetPassword_form.dart';
import 'package:eat_this_app/app/modules/auth/views/login_form.dart';
import 'package:eat_this_app/app/modules/auth/views/login_page.dart';
import 'package:eat_this_app/app/modules/auth/views/signup_form.dart';
import 'package:eat_this_app/app/modules/chat/bindings/chat_binding.dart';
import 'package:eat_this_app/app/modules/chat/views/acquiantances_page.dart';
import 'package:eat_this_app/app/modules/chat/views/chat_page.dart';
import 'package:eat_this_app/app/modules/chat/views/consultant_req_page.dart';
import 'package:eat_this_app/app/modules/chat/views/list_consultant.dart';
import 'package:eat_this_app/app/modules/home/views/home_page.dart';
import 'package:eat_this_app/app/modules/pharmacy/views/pharmacy_page.dart';
import 'package:eat_this_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:eat_this_app/app/modules/profile/views/profile_page.dart';
import 'package:eat_this_app/app/modules/scan/views/scan_view.dart';
import 'package:eat_this_app/app/modules/search/views/search_page.dart';
import 'package:eat_this_app/app/utils/bottom_nav_bar.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: '/home',
      page: () =>  PersistentBottomNavBar(),
      bindings: [
        ProfileBinding(),
        ChatBinding(),
      ],
      middlewares: [AuthMiddleware()]
      // binding: NavBindings()
      // binding: HomeBinding(),
    ),
    GetPage(name: '/beranda', page: () => const HomePage()),
    GetPage(name: '/search', page: () => const SearchPage()),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/scan', page: () =>  ScanPage()),
    GetPage(name: '/pharmacy', page: () => const PharmacyPage()),
    GetPage(name: '/loginForm', page: () => const LoginForm()),
    GetPage(name: '/signupForm', page: () => const SignupForm()),
    GetPage(name: '/forgotPassword', page: () => const ForgotPasswordForm()),
    GetPage(name: '/profile', page: () => const ProfilePage(),binding: ProfileBinding()),

    //chat and consult
    GetPage(name: '/chat', page: () => ChatPage(), binding: ChatBinding()),
    GetPage(name: '/add-consultant', page: () => ListConsultantPage(), binding: ChatBinding()),
    GetPage(name: '/chat/room', page: () => ChatPage(), binding: ChatBinding()),
    GetPage(name: '/consultant/requests', page: () => ConsultantRequestsPage(), binding: ChatBinding()),
    GetPage(name: '/consultant/acquaitances', page: () => AcquaintancesPage(), binding: ChatBinding()),
    // tambah rute baru disini
  ];
}

class Routes {
  static const HOME = '/login';
}
