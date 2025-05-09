import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../widgets/app_colors.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = "Scan QR Code Anda";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        setState(() {
          scannedData = scanData.code!;
        });

        if (ModalRoute.of(context)?.isCurrent == true) {
          _showResultDialog(scannedData);
        }
      }
    });
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              "Hasil Scan",
              style: TextStyle(color: AppColors.textPrimary),
            ),
            content: Text(
              result,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            backgroundColor: AppColors.background,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller?.resumeCamera();
                },
                child: const Text(
                  "Tutup",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Scan QR Code",
          style: TextStyle(color: AppColors.background),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.background),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // QR Code Scanner
          Expanded(
            flex: 4,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          // Hasil Scan
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                scannedData,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
