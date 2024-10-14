import 'package:eat_this_app/app/components/CustomButton.dart';
import 'package:eat_this_app/app/components/CustomTextField.dart';
import 'package:eat_this_app/app/components/SocialLoginButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const CustomTextField(hint: "Text your email"),
            const SizedBox(height: 16),
            const Text("Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const CustomTextField(hint: "Text your password", isPassword: true),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Log In',
              isPrimary: true,
              onPressed: () {},
            ),
            const SizedBox(height: 20),
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
    );
  }
}
