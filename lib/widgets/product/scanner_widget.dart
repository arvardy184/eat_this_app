import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerWidget extends StatefulWidget {
  final Function(String) onDetect;

  ScannerWidget({super.key, required this.onDetect});

  @override
  _ScannerWidgetState createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          if (barcode.rawValue != null) {
            widget.onDetect(barcode.rawValue!);
            break;
          }
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}