import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/scan_utils.dart';
import '../../../../core/widgets/scanner_frame.dart';
import '../../../../l10n/app_localizations.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );
  bool _isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isScanned) return;
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _isScanned = true;
        await vibrateOnce();

        if (mounted) {
          context.pop(barcode.rawValue);
        }
        break; // Only take first one
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                size: 28, color: Theme.of(context).primaryColor),
            onPressed: () => context.pop(),
          ),
          title: Text(AppLocalizations.of(context).scanBarcode,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
          ),
          Center(
            child: ScannerFrame(
              size: 250,
              frameColor: Colors.green,
              cornerColor: Colors.white,
              radius: 0,
              hintText: AppLocalizations.of(context).alignBarcodeInFrame,
            ),
          ),
        ],
      ),
    );
  }
}