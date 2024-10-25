// Import other views and bindings

// part 'app_routes.dart';

import 'package:eat_this_app/app/modules/auth/views/login_form.dart';
import 'package:eat_this_app/app/modules/auth/views/login_page.dart';
import 'package:eat_this_app/app/modules/auth/views/signup_form.dart';
import 'package:eat_this_app/app/modules/auth/views/forgetPassword_form.dart';
import 'package:eat_this_app/app/modules/chat/bindings/chat_binding.dart';
import 'package:eat_this_app/app/modules/chat/views/chat_page.dart';
import 'package:eat_this_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:eat_this_app/app/modules/profile/views/profile_page.dart';
import 'package:eat_this_app/app/utils/bottom_nav_bar.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: '/home',
      page: () => PersistentBottomNavBar(),
      // binding: HomeBinding(),
    ),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/loginForm', page: () => const LoginForm()),
    GetPage(name: '/signupForm', page: () => const SignupForm()),
    GetPage(name: '/forgotPassword', page: () => const ForgotPasswordForm()),
    GetPage(name: '/profile', page: () => const ProfilePage(),binding: ProfileBinding()),
    GetPage(name: '/chat', page: () => ChatPage(), binding: ChatBinding()),
    
    // tambah rute baru disini
  ];
}

class Routes {
  static const HOME = '/login';
}
