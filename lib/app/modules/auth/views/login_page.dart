import 'package:eat_this_app/app/components/CustomButton.dart';
import 'package:eat_this_app/app/components/SocialLoginButton.dart';
import 'package:eat_this_app/app/modules/auth/views/login_form.dart';
import 'package:eat_this_app/app/modules/auth/views/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  height: Get.height * 0.5,
                  width: Get.width * 0.5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
              ),
              CustomButton(
                text: 'Log In',
                isPrimary: true,
                onPressed: () {
                  Get.to(() => LoginForm());
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Sign Up',
                isPrimary: false,
                onPressed: () {
                  Get.to(() => SignupForm());
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('Or'),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SocialLoginButton(
                text: 'Continue with Google',
                icon: 'assets/images/google_icon.png',
                onPressed: () {
                  // Handle Google login
                  print("Logging in with Google...");
                },
              ),
              SizedBox(height: 10),
              SocialLoginButton(
                text: 'Continue with Facebook',
                icon: 'assets/images/facebook_icon.png',
                onPressed: () {
                  // Handle Facebook login
                  print("Logging in with Facebook...");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
