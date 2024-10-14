import 'package:eat_this_app/app/components/CustomButton.dart';
import 'package:eat_this_app/app/components/CustomTextField.dart';
import 'package:eat_this_app/app/components/SocialLoginButton.dart';
import 'package:eat_this_app/app/modules/home/views/home_page.dart';
import 'package:eat_this_app/app/utils/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const CustomTextField(hint: "Text your email"),
            const SizedBox(height: 16),
            const Text(
              'Password',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const CustomTextField(hint: "Text your password", isPassword: true),
            const SizedBox(height: 12),
            const Text(
              'Confirm Password',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const CustomTextField(hint: "Text your password", isPassword: true),
            const SizedBox(height: 62),
            CustomButton(
              text: 'Sign Up',
              isPrimary: true,
              onPressed: () {
                // Handle login
                print("Logging in...");
                // Navigate to home page
                // Get.to(() => HomePage());
              },
            ),
            SizedBox(height: 28),
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
            SizedBox(height: 28),
            SocialLoginButton(
              text: 'Continue with Google',
              icon: 'assets/images/google_icon.png',
              onPressed: () {
                // Handle Google login
                print("Logging in with Google...");
              },
            ),
            SizedBox(height: 20),
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
    );
  }
}
