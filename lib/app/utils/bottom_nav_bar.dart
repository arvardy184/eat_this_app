// lib/widgets/persistent_bottom_nav_bar.dart
import 'package:eat_this_app/app/modules/chat/views/chat_page.dart';
import 'package:eat_this_app/app/modules/home/views/home_page.dart';
import 'package:eat_this_app/app/modules/pharmacy/views/pharmacy_page.dart';
import 'package:eat_this_app/app/modules/search/views/search_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../modules/scan/views/scan_view.dart';

class PersistentBottomNavBar extends StatelessWidget {
  const PersistentBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller;
    controller = PersistentTabController(initialIndex: 0);

    List<Widget> buildScreens() {
      return [
        HomePage(),
        const SearchPage(),
         ScanPage(),
        const PharmacyPage(),
        const ChatPage(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.search),
          title: ("Product"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
          title: ("Scan"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
          activeColorSecondary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.local_pharmacy),
          title: ("Pharmacy"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.chat),
          title: ("Chat"),
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
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      // popAllScreensOnTapOfSelectedTab: true,
      // popActionScreens: PopActionScreensType.all,
      // itemAnimationProperties: ItemAnimationProperties(
      //   duration: Duration(milliseconds: 200),
      //   curve: Curves.ease,
      // ),
      // screenTransitionAnimation: ScreenTransitionAnimation(
      //   animateTabTransition: true,
      //   curve: Curves.ease,
      //   duration: Duration(milliseconds: 200),
      // ),
      navBarStyle:
          NavBarStyle.style15, // Choose the nav bar style with this property
    );
  }
}
