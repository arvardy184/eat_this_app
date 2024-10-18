// lib/screens/scan_screen.dart
import 'package:eat_this_app/app/modules/product_details/views/product_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = true;
  bool _isLoading = false;
  Map<String, dynamic> _productData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Product')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _isScanning ? _buildScanner() : _buildProductDetails(),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isScanning = true;
                    _productData = {};
                  });
                },
                child: Text(_isScanning ? 'Stop Scanning' : 'Scan Again'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanner() {
    return MobileScanner(
      controller: cameraController,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          debugPrint('Barcode found! ${barcode.rawValue}');
          _handleDetection(barcode.rawValue ?? '');
        }
      },
    );
  }

  Widget _buildProductDetails() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_productData.isNotEmpty) {
      return ProductDetails(productData: _productData);
    } else {
      return Center(child: Text('No product data available'));
    }
  }

  void _handleDetection(String barcode) async {
    setState(() {
      _isScanning = false;
      _isLoading = true;
    });

    await fetchProductData(barcode);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchProductData(String barcode) async {
    final response = await http.get(Uri.parse('https://world.openfoodfacts.net/api/v2/product/$barcode.json'));

    print("info response body: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        setState(() {
          _productData = data['product'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product not found')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch product data')),
      );
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

