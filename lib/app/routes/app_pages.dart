// Import other views and bindings

// part 'app_routes.dart';

import 'package:eat_this_app/app/modules/auth/views/login_form.dart';
import 'package:eat_this_app/app/modules/auth/views/login_page.dart';
import 'package:eat_this_app/app/modules/auth/views/signup_form.dart';
import 'package:eat_this_app/app/modules/home/views/home_page.dart';
import 'package:eat_this_app/app/modules/auth/views/forgetPassword_form.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: '/home',
      page: () => HomePage(),
      // binding: HomeBinding(),
    ),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/loginForm', page: () => const LoginForm()),
    GetPage(name: '/signupForm', page: () => const SignupForm()),
    GetPage(name: '/forgotPassword', page: () => const ForgotPasswordForm()),

    // tambah rute baru disini
  ];
}

class Routes {
  static const HOME = '/login';
}
