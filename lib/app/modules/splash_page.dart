import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    print(Get.height * 0.5);
    print(Get.width * 0.5);
    return Scaffold(backgroundColor: Colors.white, body: _buildSplashLogo());
  }
}

Widget _buildSplashLogo() {
  return Center(
    child: Container(
      height: Get.height * 0.5,
      width: Get.width * 0.5,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logo.png'),
        ),
      ),
    ),
  );
}
