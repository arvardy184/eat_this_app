import 'package:eat_this_app/app/components/CustomButton.dart';
import 'package:eat_this_app/app/components/CustomTextField.dart';
import 'package:eat_this_app/app/hooks/use_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final UseAuth _auth = UseAuth();

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = Get.arguments as Map<String, String>;
    final email = args['email'];
    final token = args['token'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Create your new password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                hint: "Enter new password",
                isPassword: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordController,
                hint: "Confirm new password",
                isPassword: true,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Reset Password',
                isPrimary: true,
                onPressed: () async {
                  final password = _passwordController.text;
                  final confirmPassword = _confirmPasswordController.text;

                  if (password.isEmpty || confirmPassword.isEmpty) {
                    Get.snackbar('Error', 'Please fill all fields');
                    return;
                  }

                  if (password != confirmPassword) {
                    Get.snackbar('Error', 'Passwords do not match');
                    return;
                  }

                  try {
                    await _auth.resetPassword(email!, token!, password);
                     Get.snackbar(
                                'Success',
                                "Reset password has been completed",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.green[100],
                                colorText: Colors.green[900],
                              );
                  } catch (e) {
                    print("Error during reset password: $e");
                    Get.snackbar('Error', 'Failed to reset password');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}