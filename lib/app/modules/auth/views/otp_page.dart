import 'package:eat_this_app/app/components/CustomButton.dart';
import 'package:eat_this_app/app/components/CustomTextField.dart';
import 'package:eat_this_app/app/hooks/use_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({Key? key}) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _tokenController = TextEditingController();
  final UseAuth _auth = UseAuth();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    print("Email: ${Get.arguments}");
    final email = Get.arguments.runtimeType == String ? Get.arguments : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Token'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Enter the verification token sent to your email",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _tokenController,
                  hint: "Enter verification token",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Token is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Verify',
                  isPrimary: true,
                  isLoading: _isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      _auth.verifyOtp(email, _tokenController.text.trim())
                          .then((_) {
                        Get.snackbar(
                          'Success',
                          'Token verified successfully',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green[100],
                          colorText: Colors.green[900],
                        );
                      }).catchError((e) {
                        Get.snackbar(
                          'Error',
                          'Invalid token',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red[100],
                          colorText: Colors.red[900],
                        );
                      }).whenComplete(() {
                        setState(() => _isLoading = false);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }
}