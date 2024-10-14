import 'package:eat_this_app/app/modules/home/views/home_page.dart';
import 'package:eat_this_app/app/utils/bottom_nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(username: "Login"),
      body:  Column(  
      children: [
        Text("Ini login page"),
        ElevatedButton(
          onPressed: ()  {
              print("Masuk ke home");
             Get.to(PersistentBottomNavBar());
          },
          child: Text("Masuk ke home"),
        ),
      ],
    ),
    );
   
  }
}