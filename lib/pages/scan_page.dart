import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import '../widgets/app_colors.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = "Scan QR Code Anda";
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _safeCameraDispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Future<void> _safeCameraDispose() async {
    try {
      await controller?.pauseCamera();
      await controller?.stopCamera();
      controller?.dispose();
      controller = null;
    } catch (e) {
      debugPrint("Error disposing camera: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    
    final controller = this.controller;
    if (controller == null || !_isCameraInitialized) return;

    if (state == AppLifecycleState.resumed) {
      _resumeCameraWithRetry();
    } else if (state == AppLifecycleState.paused) {
      controller.pauseCamera();
    }
  }

  Future<void> _resumeCameraWithRetry({int retryCount = 3}) async {
    try {
      if (controller != null && mounted) {
        await controller!.resumeCamera();
        _isCameraInitialized = true;
      }
    } catch (e) {
      if (retryCount > 0) {
        await Future.delayed(Duration(milliseconds: 300));
        await _resumeCameraWithRetry(retryCount: retryCount - 1);
      } else {
        debugPrint("Failed to resume camera after retries: $e");
        if (mounted) {
          setState(() {
            scannedData = "Gagal memulai kamera";
          });
        }
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    _isCameraInitialized = false;

    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null && mounted) {
        setState(() {
          scannedData = scanData.code!;
        });

        if (ModalRoute.of(context)?.isCurrent == true) {
          await controller.pauseCamera();
          _showResultDialog(scannedData);
        }
      }
    }, onError: (error) {
      debugPrint("Scanner error: $error");
      if (mounted) {
        setState(() {
          scannedData = "Error: ${error.toString()}";
        });
      }
    });

    // Initial camera start with delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted && this.controller != null) {
        _resumeCameraWithRetry();
      }
    });
  }

  Future<void> _showResultDialog(String result) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              _resumeCameraWithRetry();
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

  Future<bool> _onWillPop() async {
    await _safeCameraDispose();
    return true;
  }

  void _reloadScanPage() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => ScanPage(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            onPressed: () async {
              await _safeCameraDispose();
              if (mounted) Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: AppColors.primary,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      scannedData,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (scannedData.contains("Error") || 
                        scannedData.contains("Gagal"))
                      TextButton(
                        onPressed: _reloadScanPage,
                        child: const Text(
                          "Coba Lagi",
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}