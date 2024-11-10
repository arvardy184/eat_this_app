
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/profile_controller.dart';

// ignore: must_be_immutable
class PersonalInformationPage extends GetView<ProfileController> {
  PersonalInformationPage({Key? key}) : super(key: key);

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController almaMaterController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final RxBool isEditing = false.obs;

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffix,
    String? hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled && isEditing.value,
          readOnly: readOnly,
          maxLines: maxLines,
          onTap: onTap,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: !isEditing.value || !enabled,
            fillColor: Colors.grey.shade100,
            hintText: hint,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

Widget _buildLocationPicker() {
  final currentLat = double.tryParse(latitudeController.text) ?? -7.983908;
  final currentLng = double.tryParse(longitudeController.text) ?? 112.621391;
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Location',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(currentLat, currentLng),
                  initialZoom: 15,
                  onTap: isEditing.value 
                    ? (tapPosition, latLng) {
                        latitudeController.text = latLng.latitude.toString();
                        longitudeController.text = latLng.longitude.toString();
                      }
                    : null,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: LatLng(currentLat, currentLng),
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isEditing.value)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: _getCurrentLocation,
                    child: const Icon(Icons.my_location),
                  ),
                ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Latitude',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: latitudeController,
                  enabled: isEditing.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    filled: !isEditing.value,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Longitude',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: longitudeController,
                  enabled: isEditing.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    filled: !isEditing.value,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ],
  );
}

Future<void> _getCurrentLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Error',
        'Location services are disabled. Please enable the services',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Error',
          'Location permissions are denied',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Error',
        'Location permissions are permanently denied, we cannot request permissions.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    latitudeController.text = position.latitude.toString();
    longitudeController.text = position.longitude.toString();
    
    Get.snackbar(
      'Success',
      'Location updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to get current location: $e',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

  Widget _buildAllergySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Allergies',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: isEditing.value ? () => _showAllergensDialog(Get.context!) : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: !isEditing.value ? Colors.grey.shade100 : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Selected Allergies'),
                    if (isEditing.value) const Icon(Icons.arrow_drop_down),
                  ],
                ),
                if (controller.allergens.any((a) => a.isSelected)) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.allergens
                        .where((a) => a.isSelected)
                        .map((allergen) => Chip(
                              label: Text(allergen.name),
                              backgroundColor: Colors.blue,
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleMapTap(LatLng position) {
    latitudeController.text = position.latitude.toString();
    longitudeController.text = position.longitude.toString();
    // You might want to reverse geocode the position to get the address
    // and update addressController
  }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     final position = await Geolocator.getCurrentPosition();
  //     latitudeController.text = position.latitude.toString();
  //     longitudeController.text = position.longitude.toString();
  //     // You might want to reverse geocode the position to get the address
  //     // and update addressController
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to get current location',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    nameController.text = controller.user.value?.name ?? '';
    emailController.text = controller.user.value?.email ?? '';
    final packageName = controller.user.value?.type ?? '';
    print("apa package name $packageName");
    
    if (packageName == 'Consultant') {
      almaMaterController.text = controller.user.value?.almamater ?? '';
      specializationController.text = controller.user.value?.specialization ?? '';
    } else if (packageName == 'Pharmacy') {
      addressController.text = controller.user.value?.address ?? '';
      latitudeController.text = controller.user.value?.latitude?.toString() ?? '0';
      longitudeController.text = controller.user.value?.longitude?.toString() ?? '0';
    }

    if (controller.user.value?.birthDate != null && dateController.text.isEmpty) {
      try {
        final date = DateTime.parse(controller.user.value!.birthDate!);
        selectedDate.value = date;
        dateController.text = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        centerTitle: true,
        leading: isEditing.value
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _handleCancel,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
        actions: [
          TextButton(
            onPressed: () => _handleEditSave(context),
            child: Text(
              isEditing.value ? 'Save' : 'Edit',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'Name',
                controller: nameController,
                hint: 'Enter your name',
              ),
              _buildTextField(
                label: 'Email',
                controller: emailController,
                enabled: false,
              ),
              _buildTextField(
                label: 'Date of Birth',
                controller: dateController,
                readOnly: true,
                onTap: isEditing.value ? () => _selectDate(context) : null,
                suffix: const Icon(Icons.calendar_today),
                hint: 'Select date of birth',
              ),
              if (packageName == 'Consultant') ...[
                _buildTextField(
                  label: 'Almamater',
                  controller: almaMaterController,
                  hint: 'Enter your alma mater',
                ),
                _buildTextField(
                  label: 'Specialization',
                  controller: specializationController,
                  hint: 'Enter your specialization',
                ),
              ] else if (packageName == 'Pharmacy') ...[
                _buildTextField(
                  label: 'Address',
                  controller: addressController,
                  maxLines: 3,
                  hint: 'Enter pharmacy address',
                ),
                if (isEditing.value) _buildLocationPicker(),
              ],
              _buildAllergySection(),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _showAllergensDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Allergies'),
          content: SingleChildScrollView(
            child: Obx(() => Column(
                  children: List.generate(
                    controller.allergens.length,
                    (index) => CheckboxListTile(
                      title: Text(controller.allergens[index].name),
                      value: controller.allergens[index].isSelected,
                      onChanged: (bool? value) {
                        controller.toggleAllergen(index);
                      },
                    ),
                  ),
                )),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleEditSave(BuildContext context) async {
    if (isEditing.value) {
      // Save changes
      try {
        // Format the date to YYYY-MM-DD for API
        String? formattedDate;
        if (selectedDate.value != null) {
          formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
        }

        await controller.updateUserInfo(
          name: nameController.text,
          dateOfBirth: formattedDate,
          allergens: controller.selectedAllergens,
        );

        // Sukses update, kembalikan ke mode view
        isEditing.value = false;
        Get.snackbar(
          'Success',
          'Personal information updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        // Jika error, tetap di mode edit
        print('Error saving: $e');
        Get.snackbar(
          'Error',
          'Failed to update personal information',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      // Ketika user tekan tombol edit, simpan data awal dan aktifkan mode edit
      _startEditing();
    }
  }

// Method untuk memulai mode edit
  void _startEditing() {
    // Simpan nilai awal untuk keperluan cancel
    _originalName = nameController.text;
    _originalDate = dateController.text;
    _originalSelectedDate = selectedDate.value;
    _originalAllergenStates =
        controller.allergens.map((allergen) => allergen.isSelected).toList();

    // Aktifkan mode edit
    isEditing.value = true;
  }

// Method untuk membatalkan edit
  void _handleCancel() {
    // Kembalikan ke nilai awal
    nameController.text = _originalName;
    dateController.text = _originalDate;
    selectedDate.value = _originalSelectedDate;

    // Kembalikan state allergen
    for (var i = 0; i < controller.allergens.length; i++) {
      if (i < _originalAllergenStates.length) {
        controller.allergens[i].isSelected = _originalAllergenStates[i];
      }
    }
    controller.allergens.refresh();

    // Nonaktifkan mode edit
    isEditing.value = false;
  }

  // Variables to store original values
  late String _originalName;
  late String _originalDate;
  late DateTime? _originalSelectedDate;
  late List<bool> _originalAllergenStates;
}
