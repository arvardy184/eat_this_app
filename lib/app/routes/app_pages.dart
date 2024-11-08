import 'package:eat_this_app/app/middleware/auth_middleware.dart';
import 'package:eat_this_app/app/modules/auth/views/forgetPassword_form.dart';
import 'package:eat_this_app/app/modules/auth/views/login_form.dart';
import 'package:eat_this_app/app/modules/auth/views/login_page.dart';
import 'package:eat_this_app/app/modules/auth/views/signup_form.dart';
import 'package:eat_this_app/app/modules/chat/bindings/chat_binding.dart';
import 'package:eat_this_app/app/modules/chat/bindings/subscription_binding.dart';
import 'package:eat_this_app/app/modules/chat/views/acquiantances_page.dart';
import 'package:eat_this_app/app/modules/chat/views/chat_page.dart';
import 'package:eat_this_app/app/modules/chat/views/chat_room_page.dart';
import 'package:eat_this_app/app/modules/chat/views/consultant_req_page.dart';
import 'package:eat_this_app/app/modules/chat/views/list_consultant.dart';
import 'package:eat_this_app/app/modules/home/bindings/home_binding.dart';
import 'package:eat_this_app/app/modules/home/views/home_page.dart';
import 'package:eat_this_app/app/modules/pharmacy/bindings/pharmacy_binding.dart';
import 'package:eat_this_app/app/modules/pharmacy/views/pharmacy_detail_page.dart';
import 'package:eat_this_app/app/modules/pharmacy/views/pharmacy_page.dart';
import 'package:eat_this_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:eat_this_app/app/modules/profile/views/profile_page.dart';
import 'package:eat_this_app/app/modules/scan/bindings/alternative_bindings.dart';
import 'package:eat_this_app/app/modules/scan/views/scan_view.dart';
import 'package:eat_this_app/app/modules/search/bindings/search_bindings.dart';
import 'package:eat_this_app/app/modules/search/views/search_page.dart';
import 'package:eat_this_app/app/utils/bottom_nav_bar.dart';
import 'package:eat_this_app/app/utils/term_of_service.dart';
import 'package:get/get.dart';

import '../modules/scan/views/alternative_product_page.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: '/home', page: () => PersistentBottomNavBar(),
    binding: HomeBinding(), 
    bindings: [
      ProfileBinding(),
      ChatBinding(),
      PharmacyBinding(),
      SubscriptionBinding(),
    ], middlewares: [
      AuthMiddleware()
    ]
        ),
  
    GetPage(
        name: '/search', page: () => SearchPage(), binding: SearchBinding()),
    GetPage(
        name: '/beranda',
        page: () => HomePage(),
        binding: HomeBinding(),
        bindings: [
          SubscriptionBinding(),
        ]),
    GetPage(name: '/search', page: () => SearchPage()),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/scan', page: () => ScanPage()),
    GetPage(name: '/loginForm', page: () => const LoginForm()),
    GetPage(name: '/signupForm', page: () => const SignupForm()),
    GetPage(name: '/forgotPassword', page: () => const ForgotPasswordForm()),
    GetPage(
        name: '/profile',
        page: () => const ProfilePage(),
        binding: ProfileBinding()),
    GetPage(
        name: '/pharmacy',
        page: () => PharmacyPage(),
        bindings: [PharmacyBinding()]),

   GetPage(
      name:'/terms',
      page: () => const TermsOfServicePage(),
    ),

    GetPage(
        name: '/chat',
        page: () => ChatPage(),
        binding: ChatBinding(),
        bindings: [
          SubscriptionBinding(),
        ]),
    GetPage(
        name: '/add-consultant',
        page: () => ListConsultantPage(),
        binding: ChatBinding()),
    GetPage(
        name: '/consultant/requests',
        page: () => ConsultantRequestsPage(),
        binding: ChatBinding()),
    GetPage(
        name: '/consultant/acquaitances',
        page: () => AcquaintancesPage(),
        binding: ChatBinding()),

    GetPage(
        name: '/chat/room', page: () => ChatRoomPage(), binding: ChatBinding()),
    GetPage(
      name: '/product/alternative',
      page: () => AlternativeProductPage(),
      binding: AlternativeProductBinding(),
    ),
  ];
}

class Routes {
  static const HOME = '/login';
}
