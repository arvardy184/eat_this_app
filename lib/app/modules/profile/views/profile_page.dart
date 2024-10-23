import 'package:eat_this_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        final user = controller.user.value;
        if (user == null) {
          return Center(child: Text('No user data available'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture and Name
              CircleAvatar(
                radius: 50,
                backgroundImage: user.profilePicture != null
                    ? NetworkImage(user.profilePicture!)
                    : AssetImage('assets/images/default_avatar.png') as ImageProvider,
              ),
              const SizedBox(height: 10),
              Text(
                user.name ?? 'No Name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              
              // Premium Badge
              if (user.packageId != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: CIETTheme.secondary_color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Premium Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Allergies Section
              if (user.allergens != null && user.allergens!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.blue.shade50,
                  child: Column(
                    children: [
                      const Text(
                        "My Allergen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: user.allergens!.map((allergen) =>
                            _buildAllergyTag(allergen.name ?? '', Colors.orange)
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
 // Account Settings
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Personal information"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Language"),
              trailing: const Text("English (US)", style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Policy"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Setting"),
              onTap: () {},
            ),
            const Divider(),

            // More Section
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Help Center"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Log Out", style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAllergyTag(String label, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}