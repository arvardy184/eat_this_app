import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${DateTime.now().toString().split(' ')[0]}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              title: '1. Introduction',
              content: 'Welcome to CanIEatThis ("we," "our," or "us"). By accessing or using our application, you agree to be bound by these Terms of Service.',
            ),

            _buildSection(
              context,
              title: '2. Use of Service',
              content: 'Our service provides food allergy and intolerance information through barcode scanning and expert consultation. While we strive for accuracy, we cannot guarantee the completeness or accuracy of all information.',
              subsections: {
                'Account Registration': 'You must register an account to use certain features. You are responsible for maintaining the confidentiality of your account.',
                'User Conduct': 'You agree not to misuse the service or help anyone else do so.',
                'Service Availability': 'We strive to provide uninterrupted service but cannot guarantee it will always be available.',
              },
            ),

            _buildSection(
              context,
              title: '3. Subscription and Payments',
              content: 'We offer both free and premium subscription plans.',
              subsections: {
                'Free Plan': 'Includes basic features with limited scans and no consultation access.',
                'Premium Plan': 'Offers additional features including expert consultation and unlimited scans.',
                'Payment Terms': 'Premium subscriptions are processed through our administrator via WhatsApp.',
                'Refund Policy': 'No refunds are provided for unused subscription periods.',
              },
            ),

            _buildSection(
              context,
              title: '4. Health Disclaimer',
              content: 'The information provided through our service is for informational purposes only and should not replace professional medical advice.',
              subsections: {
                'Not Medical Advice': 'Our service does not provide medical diagnoses or treatment recommendations.',
                'Consult Healthcare Providers': 'Always consult with qualified healthcare providers regarding your specific health conditions.',
                'Emergency Situations': 'In case of allergic reactions or medical emergencies, seek immediate medical attention.',
              },
            ),

            _buildSection(
              context,
              title: '5. Privacy and Data',
              content: 'We collect and process your data in accordance with our Privacy Policy.',
              subsections: {
                'Data Collection': 'We collect information about your food preferences, allergies, and usage patterns.',
                'Data Security': 'We implement reasonable security measures to protect your information.',
                'Third-Party Services': 'We may use third-party services to process data and provide features.',
              },
            ),

            _buildSection(
              context,
              title: '6. User Content',
              content: 'You retain ownership of content you submit but grant us license to use it.',
              subsections: {
                'Content License': 'You grant us a worldwide, non-exclusive license to use content you submit.',
                'Prohibited Content': 'You agree not to submit inappropriate or harmful content.',
                'Content Removal': 'We reserve the right to remove any content that violates our terms.',
              },
            ),

            _buildSection(
              context,
              title: '7. Termination',
              content: 'We may terminate or suspend your account for violations of these terms.',
            ),

            _buildSection(
              context,
              title: '8. Changes to Terms',
              content: 'We may modify these terms at any time. Continued use of the service constitutes acceptance of modified terms.',
            ),

            _buildSection(
              context,
              title: '9. Contact Us',
              content: 'If you have any questions about these Terms, please contact us at:',
              contactInfo: true,
            ),

            const SizedBox(height: 32),
            
            Center(
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('I Understand'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    Map<String, String>? subsections,
    bool contactInfo = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (subsections != null) ...[
          const SizedBox(height: 16),
          ...subsections.entries.map((entry) => _buildSubsection(
            context,
            title: entry.key,
            content: entry.value,
          )),
        ],
        if (contactInfo) ...[
          const SizedBox(height: 16),
          _buildContactInfo(context),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Center(
              child: Text(
                "Made with 🫶🏿 by Arvan, Zidan, and Riady",
                textAlign: TextAlign.center,
              )
            )
          ),
        ],
         
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSubsection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• $title',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContactItem(
            icon: Icons.email,
            title: 'Email',
            content: 'arvanardana1@gmail.com',
          ),
          const SizedBox(height: 8),
          _buildContactItem(
            icon: Icons.phone,
            title: 'Phone',
            content: '+62 851-5653-6353',
          ),
          const SizedBox(height: 8),
          _buildContactItem(
            icon: Icons.location_on,
            title: 'Address',
            content: 'Jl. Veteran, Ketawanggede, Kec. Lowokwaru, Kota Malang, Jawa Timur 65145',
          ),

         
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(content),
            ],
          ),
        ),
      ],
    );
  }
}