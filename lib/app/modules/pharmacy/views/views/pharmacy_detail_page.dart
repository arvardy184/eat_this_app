import 'package:eat_this_app/app/themes/app_theme.dart';
import 'package:eat_this_app/services/pharmacy_service.dart';
import 'package:flutter/material.dart';
import 'package:eat_this_app/app/data/models/pharmacy_model.dart';

class PharmacyDetailPage extends StatefulWidget {
  final String pharmacyId;

  const PharmacyDetailPage({super.key, required this.pharmacyId});

  @override
  _PharmacyDetailPageState createState() => _PharmacyDetailPageState();
}

class _PharmacyDetailPageState extends State<PharmacyDetailPage> {
  final PharmacyService _pharmacyService = PharmacyService();
  List<Medicine> medicines = [];

  @override
  void initState() {
    super.initState();
    _getMedicines();
  }

  Future<void> _getMedicines() async {
    final List<Medicine> fetchedMedicines =
        await _pharmacyService.getPharmacyMedicines(widget.pharmacyId);
    setState(() {
      medicines = fetchedMedicines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Apotek"),
        backgroundColor: CIETTheme.primary_color,
      ),
      body: medicines.isEmpty
          ? const Center(child: Text("Belum ada obat"))
          : ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return ListTile(
                  title: Text(medicine.name),
                  subtitle: Text(medicine.dosage),
                );
              },
            ),
    );
  }
}
