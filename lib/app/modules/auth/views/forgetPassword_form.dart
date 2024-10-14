import 'package:eat_this_app/app/components/CustomButton.dart';
import 'package:eat_this_app/app/components/CustomTextField.dart';
import 'package:eat_this_app/app/components/SocialLoginButton.dart';
import 'package:eat_this_app/app/modules/auth/views/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
                "Enter the email associated with your account and we’ll send an email with code to reset your password",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 23),
            const Text("Email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const CustomTextField(hint: "Text your email"),
            const SizedBox(height: 35),
            CustomButton(
              text: 'Confirm',
              isPrimary: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
