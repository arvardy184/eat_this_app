import 'package:eat_this_app/app/modules/home/views/home_page.dart';
import 'package:eat_this_app/app/modules/pharmacy/controllers/pharmacy_controller.dart';
import 'package:eat_this_app/services/pharmacy_service.dart';
import 'package:flutter/material.dart';
import 'package:eat_this_app/app/data/models/pharmacy_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class PharmacyDetailPage extends StatefulWidget {
  final String pharmacyId;
  final double latitude;
  final double longitude;
  final String name;

  const PharmacyDetailPage({
    super.key,
    required this.pharmacyId,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  @override
  _PharmacyDetailPageState createState() => _PharmacyDetailPageState();
}

class _PharmacyDetailPageState extends State<PharmacyDetailPage> {
  final PharmacyService _pharmacyService = PharmacyService();
  final PharmacyController pharmacyController = Get.find<PharmacyController>();
  final MapController mapController = MapController();
  List<Medicine> medicines = [];
  bool get isOwner => pharmacyController.isOwner.value;

  @override
  void initState() {
    super.initState();
    _getMedicines();
    print(isOwner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        leading: isOwner
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.offNamed('/home'),
              )
            : null,
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddMedicineDialog,
            ),
        ],
      ),
      body: Column(
        children: [
          isOwner
              ? Container()
              : Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter:
                            LatLng(widget.latitude, widget.longitude),
                        initialZoom: 16.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(widget.latitude, widget.longitude),
                              child: const Icon(
                                Icons.local_pharmacy,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border(
                  bottom: BorderSide(color: Colors.blue.shade200, width: 3),
                ),
              ),
              child: const Text(
                "Daftar Obat",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue.shade50,
              child: RefreshIndicator(
                onRefresh: _getMedicines,
                child: medicines.isEmpty
                    ? const Center(
                        child: Text(
                          "Belum ada obat",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: medicines.length,
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(
                            color: Colors.blue.shade200,
                            thickness: 3,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          final medicine = medicines[index];
                          return Container(
                            color: Colors.blue.shade50,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Row(
                                children: [
                                  // Image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.blue.shade200,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: medicine.imageUrl != null
                                          ? Image.network(
                                              medicine.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.medication,
                                                      size: 40,
                                                      color: Colors.blue),
                                            )
                                          : const Icon(Icons.medication,
                                              size: 40, color: Colors.blue),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Medicine Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          medicine.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          medicine.content,
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isOwner) ...[
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          _showEditMedicineDialog(medicine),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          _showDeleteConfirmation(medicine.id),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getMedicines() async {
    final List<Medicine> fetchedMedicines =
        await _pharmacyService.getPharmacyMedicines(widget.pharmacyId);
    setState(() {
      medicines = fetchedMedicines;
    });
  }

  void _showAddMedicineDialog() {
    final nameController = TextEditingController();
    final contentController = TextEditingController();
    final imageUrlController = TextEditingController();
    bool isLoading = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tambah Obat',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Obat',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: contentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL Gambar',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isLoading ? null : () => Get.back(),
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (nameController.text.isEmpty ||
                                    contentController.text.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Nama dan deskripsi harus diisi',
                                    backgroundColor: Colors.red.shade100,
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  await pharmacyController.addMedicine(
                                    widget.pharmacyId,
                                    nameController.text,
                                    contentController.text,
                                    imageUrlController.text,
                                  );

                                  // Tunggu sebentar untuk memastikan state sudah terupdate
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));

                                  if (mounted) {
                                    await _getMedicines(); // Refresh list setelah dialog tertutup
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'Gagal menambahkan obat: $e',
                                    backgroundColor: Colors.red.shade100,
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                      Navigator.of(context).pop();
                                    });
                                  }
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text('Simpan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: false, // Prevent closing by tapping outside
    );
  }

  void _showEditMedicineDialog(Medicine medicine) {
    final nameController = TextEditingController(text: medicine.name);
    final contentController = TextEditingController(text: medicine.content);
    final imageUrlController = TextEditingController(text: medicine.imageUrl);
    bool isLoading = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Obat',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Obat',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: contentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL Gambar',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isLoading ? null : () => Get.back(),
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (nameController.text.isEmpty ||
                                    contentController.text.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Nama dan deskripsi harus diisi',
                                    backgroundColor: Colors.red.shade100,
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  await pharmacyController.updateMedicine(
                                    medicine.id,
                                    nameController.text,
                                    contentController.text,
                                    imageUrlController.text,
                                  );

                                  await Future.delayed(
                                      const Duration(milliseconds: 100));

                                  if (mounted) {
                                    await _getMedicines();
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                      Navigator.of(context).pop();
                                    });
                                  }
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text('Simpan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  void _showDeleteConfirmation(String medicineId) {
    bool isLoading = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah Anda yakin ingin menghapus obat ini?'),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Get.back(),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await pharmacyController.deleteMedicine(medicineId);
                          await Future.delayed(
                              const Duration(milliseconds: 100));
                          if (mounted) {
                            await _getMedicines();
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                              Navigator.of(context).pop();
                            });
                          }
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          );
        },
      ),
      barrierDismissible: false,
    );
  }
}
