import 'package:eat_this_app/app/components/CustomButton.dart';
import 'package:eat_this_app/app/components/CustomTextField.dart';
import 'package:eat_this_app/app/components/SocialLoginButton.dart';
import 'package:eat_this_app/app/modules/auth/views/forgetPassword_form.dart';
import 'package:eat_this_app/app/modules/auth/views/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool rememberMe = false;

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
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  activeColor: Colors.green,
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),
                const Text(
                  "Remember me",
                  style: TextStyle(fontSize: 12),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Get.off(() => const ForgotPasswordForm());
                  },
                  child: const Text("Forgot Password?",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Log In',
              isPrimary: true,
              onPressed: () {},
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(width: 10),
                const Text('Or'),
                const SizedBox(width: 10),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
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
            SizedBox(height: 38),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    // Handle sign up
                    Get.off(() => SignupForm());
                  },
                  child: const Text("Sign Up",
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
