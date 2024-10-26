import 'package:eat_this_app/app/data/models/allergen_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/profile_controller.dart';

class PersonalInformationPage extends GetView<ProfileController> {
  PersonalInformationPage({Key? key}) : super(key: key);

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final RxBool isEditing = false.obs;

  @override
  Widget build(BuildContext context) {
    nameController.text = controller.user.value?.name ?? '';
    emailController.text = controller.user.value?.email ?? '';

    if (controller.user.value?.birthDate != null &&
        dateController.text.isEmpty) {
      try {
        final date = DateTime.parse(controller.user.value!.birthDate!);
        selectedDate.value = date;
        dateController.text = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text('Personal Information'),
            centerTitle: true,
            leading: isEditing.value
                ? IconButton(
                    icon: Icon(Icons.close),
                    onPressed: _handleCancel,
                  )
                : IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
            actions: [
              Obx(() => TextButton(
                    onPressed: () => _handleEditSave(context),
                    child: Text(
                      isEditing.value ? 'Save' : 'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    enabled: isEditing.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your name',
                      filled: !isEditing.value,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date of Birth',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    enabled: isEditing.value,
                    onTap: isEditing.value ? () => _selectDate(context) : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select date of birth',
                      suffixIcon: Icon(Icons.calendar_today),
                      filled: !isEditing.value,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Allergies',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: isEditing.value
                        ? () => _showAllergensDialog(context)
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                        color: !isEditing.value ? Colors.grey[200] : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.allergens
                                  .where((a) => a.isSelected)
                                  .map((allergen) => Chip(
                                        label: Text(allergen.name),
                                        backgroundColor: Colors.orange,
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                      ))
                                  .toList(),
                            ),
                          ),
                          if (isEditing.value) Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
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
