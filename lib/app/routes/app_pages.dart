import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/middleware/auth_middleware.dart';
import 'package:eat_this_app/app/modules/auth/views/forgetPassword_form.dart';
import 'package:eat_this_app/app/modules/auth/views/login_form.dart';
import 'package:eat_this_app/app/modules/auth/views/login_page.dart';
import 'package:eat_this_app/app/modules/auth/views/otp_page.dart';
import 'package:eat_this_app/app/modules/auth/views/reset_password_page.dart';
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
import 'package:eat_this_app/app/modules/profile/views/change_password_page.dart';
import 'package:eat_this_app/app/modules/profile/views/profile_page.dart';
import 'package:eat_this_app/app/modules/scan/bindings/alternative_bindings.dart';
import 'package:eat_this_app/app/modules/scan/controllers/alternative_controller.dart';
import 'package:eat_this_app/app/modules/scan/views/scan_view.dart';
import 'package:eat_this_app/app/modules/search/bindings/search_bindings.dart';
import 'package:eat_this_app/app/modules/search/views/product_detail_page.dart';
import 'package:eat_this_app/app/modules/search/views/search_page.dart';
import 'package:eat_this_app/app/utils/bottom_nav_bar.dart';
import 'package:eat_this_app/app/utils/term_of_service.dart';
import 'package:eat_this_app/widgets/home/all_scan_page.dart';
import 'package:get/get.dart';

import '../modules/scan/views/alternative_product_page.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
        name: '/home',
        page: () => PersistentBottomNavBar(),
        binding: HomeBinding(),
        bindings: [
          ProfileBinding(),
          ChatBinding(),
          PharmacyBinding(),
          SubscriptionBinding(),
        ],
        middlewares: [
          AuthMiddleware()
        ]),
    GetPage(
        name: '/search', page: () => SearchPage(), binding: SearchBinding()),
   GetPage(
  name: '/product/alternative',
  
  page: () => AlternativeProductPage(),
  binding: AlternativeProductBinding(),
  
  transition: Transition.rightToLeft,
  
),
    GetPage(
        name: '/beranda',
        page: () => HomePage(),
        binding: HomeBinding(),
        bindings: [
          SubscriptionBinding(),
        ]),
    GetPage(
        name: '/search', page: () => SearchPage(), binding: SearchBinding()),
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
      name: '/terms',
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
      name: '/all-scan',
      page: () => const AllScanPage(),
      binding: HomeBinding(),
    ),
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
    // GetPage(
    //   name: '/product/alternative',
    //   page: () => AlternativeProductPage(),
    //   binding: AlternativeProductBinding(),
    // ),
    GetPage(name: '/change-password', page: () => const ChangePasswordPage(), binding: ProfileBinding()),
    GetPage(name: '/otp', page: () => const OtpVerificationPage()),
GetPage(name: '/reset-password', page: () => const ResetPasswordPage()),
  ];
}

class Routes {
  static const HOME = '/login';
}
