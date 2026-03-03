import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class BarcodeService {
  Future<void> scanBarcode(BuildContext context) async {
    try {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AiBarcodeScanner(
            onScan: (String value) {
              _searchProduct(context, value);
              Navigator.of(context).pop();
            },
            onDetect: (BarcodeCapture capture) {
              final String? scannedValue = capture.barcodes.firstOrNull?.rawValue;
              if (scannedValue != null) {
                _searchProduct(context, scannedValue);
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Barkod tarama hatası: $e')),
        );
      }
    }
  }

  Future<void> _searchProduct(BuildContext context, String barcode) async {
    final searchQuery = Uri.encodeComponent('$barcode ürün fiyat');
    final url = Uri.parse('https://www.google.com/search?q=$searchQuery');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarayıcı açılamadı')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arama hatası: $e')),
        );
      }
    }
  }
}
