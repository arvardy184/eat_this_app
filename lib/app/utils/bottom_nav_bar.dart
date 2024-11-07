// lib/widgets/persistent_bottom_nav_bar.dart
import 'package:eat_this_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:eat_this_app/app/modules/chat/views/chat_page.dart';
import 'package:eat_this_app/app/modules/home/controllers/home_controller.dart';
import 'package:eat_this_app/app/modules/home/views/home_page.dart';
import 'package:eat_this_app/app/modules/pharmacy/controllers/pharmacy_controller.dart';
import 'package:eat_this_app/app/modules/pharmacy/views/pharmacy_page.dart';
import 'package:eat_this_app/app/modules/scan/controllers/scan_controller.dart';
import 'package:eat_this_app/app/modules/scan/views/scan_view.dart';
import 'package:eat_this_app/app/modules/search/views/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PersistentBottomNavBar extends StatelessWidget {
  const PersistentBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    List<Widget> buildScreens() {
      return [
        // Gunakan GetX untuk inject dependencies
        GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) => HomePage(),
        ),
        // GetBuilder<HomeController>(
        //   init: HomeController(),
        //   builder: (controller) => HomePage(),
        // ),
        SearchPage(),
        // GetBuilder<SearchController>(
        //   init: SearchController(),
        //   builder: (controller) => const SearchPage(),
        // ),
        GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) => ScanPage(),
        ),
        PharmacyPage(),
        // GetBuilder<PharmacyController>(
        //   init: PharmacyController(),
        //   builder: (controller) => PharmacyPage(),
        // ),
        GetBuilder<ChatController>(
          init: ChatController(),
          builder: (controller) => ChatPage(),
        ),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home_rounded),
          title: "Home",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.search_rounded),
          title: "Product",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
          ),
          title: "Scan",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
          activeColorSecondary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.local_pharmacy_rounded),
          title: "Pharmacy",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.chat_rounded),
          title: "Chat",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: controller,
      screens: buildScreens(),
      items: navBarsItems(),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      navBarStyle: NavBarStyle.style15,
      // screenTransitionAnimation: const ScreenTransitionAnimation(
      //   animateTabTransition: true,
      //   curve: Curves.easeInOut,
      //   duration: Duration(milliseconds: 200),
      // ),
    );
  }
}
