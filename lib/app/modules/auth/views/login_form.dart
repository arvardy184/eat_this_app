import 'package:eat_this_app/app/components/CustomButton.dart';
import 'package:eat_this_app/app/components/CustomTextField.dart';
import 'package:eat_this_app/app/components/SocialLoginButton.dart';
import 'package:eat_this_app/app/hooks/use_auth.dart';
import 'package:eat_this_app/app/modules/auth/views/forgetPassword_form.dart';
import 'package:eat_this_app/app/modules/auth/views/signup_form.dart';
import 'package:eat_this_app/app/themes/app_theme.dart';
import 'package:eat_this_app/app/utils/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool rememberMe = false;
  bool _isLoading = false;

  final UseAuth _auth = UseAuth();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Email",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomTextField(
                  controller: _emailController, hint: "Text your email"),
              const SizedBox(height: 16),
              const Text("Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomTextField(
                  controller: _passwordController,
                  hint: "Text your password",
                  isPassword: true),
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
                  // TextButton(
                  //   onPressed: () {
                  //     Get.off(() => const ForgotPasswordForm());
                  //   },
                  //   child: const Text("Forgot Password?",
                  //       style: TextStyle(fontSize: 12, color: Colors.grey)),
                  // ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Log In',
                isPrimary: true,
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 28),
           
      
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
                        style: TextStyle(color: CIETTheme.primary_color)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      await _auth.login(_emailController.text, _passwordController.text);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
