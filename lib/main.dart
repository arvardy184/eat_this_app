import 'package:eat_this_app/app/modules/splash_page.dart';
import 'package:eat_this_app/app/routes/app_pages.dart';
import 'package:eat_this_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const CIETApp());
  });
}

class CIETApp extends StatelessWidget {
  const CIETApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: CIETTheme.primary_color,
    ));
    return GetMaterialApp(
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      theme: setupTheme(),
      home: const SplashPage(),
    );
  }

  ThemeData setupTheme() {
    return ThemeData(
      useMaterial3: true,
      textTheme: const TextTheme(
        labelLarge: TextStyle(
            fontFamily: CIETTheme.font_family, fontSize: CIETTheme.font_size),
        displayLarge: TextStyle(fontFamily: CIETTheme.font_family),
        displaySmall: TextStyle(fontFamily: CIETTheme.font_family),
        headlineMedium:
            TextStyle(fontFamily: CIETTheme.font_family, color: Colors.black),
        bodyLarge: TextStyle(
          fontFamily: CIETTheme.font_family,
          // fontSize: CIETTheme.font_sizer
        ),
        bodyMedium: TextStyle(
            fontFamily: CIETTheme.font_family, fontSize: CIETTheme.font_size),
        titleMedium: TextStyle(
          fontFamily: CIETTheme.font_family,
        ),
        titleSmall: TextStyle(
          fontFamily: CIETTheme.font_family,
        ),
        bodySmall: TextStyle(
          fontFamily: CIETTheme.font_family,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(
              fontFamily: CIETTheme.font_family,
              fontSize: CIETTheme.font_size)),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange)
          .copyWith(surface: CIETTheme.bg_color),
    );
  }
}
