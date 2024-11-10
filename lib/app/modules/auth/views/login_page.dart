import 'package:eat_this_app/app/components/CustomButton.dart';
import 'package:eat_this_app/app/components/SocialLoginButton.dart';
import 'package:eat_this_app/app/modules/auth/views/login_form.dart';
import 'package:eat_this_app/app/modules/auth/views/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
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
                  height: Get.height * 0.3, // Reduced height
                  width: Get.width * 0.5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildUserTypeCards(),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Log In',
                isPrimary: true,
                onPressed: () => Get.to(() => LoginForm()),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Sign Up',
                isPrimary: false,
                onPressed: () => Get.to(() => SignupForm()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Join As',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                title: 'Pharmacy',
                icon: Icons.local_pharmacy,
                color: Colors.blue,
                onTap: () => _showPharmacyInfo(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                title: 'Consultant',
                icon: Icons.medical_services,
                color: Colors.green,
                onTap: () => _showConsultantInfo(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Learn More',
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPharmacyInfo() {
    
    Get.bottomSheet(
        enterBottomSheetDuration: Duration(milliseconds: 300),
  exitBottomSheetDuration: Duration(milliseconds: 200),
      PharmacyInfoSheet(),
      isScrollControlled: true,
    );
  }

  void _showConsultantInfo() {
    Get.bottomSheet(
        enterBottomSheetDuration: Duration(milliseconds: 300),
  exitBottomSheetDuration: Duration(milliseconds: 200),
      ConsultantInfoSheet(),
      isScrollControlled: true,
    );
  }
}


class PharmacyInfoSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_pharmacy, color: Colors.blue, size: 30),
              const SizedBox(width: 12),
              const Text(
                'Join as a Pharmacy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'Requirements',
            items: [
              'Valid pharmacy license',
              'Physical store location',
              'Business registration',
              'Professional pharmacist on staff',
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Benefits',
            items: [
              'Connect with customers searching for allergy medications',
              'Receive real-time alerts for medicine requests',
              'Manage inventory efficiently',
              'Build customer loyalty through the platform',
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'How to Join',
            items: [
              '1. Register as a pharmacy',
              '2. Submit required documents',
              '3. Complete verification process',
              '4. Set up your pharmacy profile',
              '5. Start receiving customer requests',
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Get Started',
              isPrimary: true,
              onPressed: () => contactAdmin('Pharmacy'),
            ),
          ),
        ],
      ),
    );
  }
}

class ConsultantInfoSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services, color: Colors.green, size: 30),
              const SizedBox(width: 12),
              const Text(
                'Join as a Consultant',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'Requirements',
            items: [
              'Professional certification in nutrition or related field',
              'Minimum 2 years experience',
              'Specialization in food allergies (preferred)',
              'Professional liability insurance',
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Benefits',
            items: [
              'Flexible consultation hours',
              'Connect with clients needing allergy advice',
              'Build your online presence',
              'Earn through virtual consultations',
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'How to Join',
            items: [
              '1. Register as a consultant',
              '2. Submit credentials for verification',
              '3. Complete profile setup',
              '4. Pass platform assessment',
              '5. Start accepting consultations',
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Get Started',
              isPrimary: true,
              onPressed: () => contactAdmin('Consultant'),
            ),
          ),
        ],
      ),
    );
  }
}

  Future<void> contactAdmin(String type) async {
    final waUrl = getWhatsAppLink(type);
    launchUrlString(waUrl);
    print("launchUrlString: $waUrl");
  }

Widget _buildSection({required String title, required List<String> items}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
    ],
  );
}


   String getWhatsAppLink(String type) {

    // Ganti dengan nomor WhatsApp admin
    const adminPhone = '+6285156536353';
    final message = 'Halo, saya ingin bergabung ke CanIEatThis? sebagai ${type}';

    final encodedMessage = Uri.encodeFull(message);
    return 'https://wa.me/$adminPhone?text=$encodedMessage';
  }
