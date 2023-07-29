import 'package:flutter/material.dart';
import 'package:lashamezvrishvili_artteo/custom/url_launcher.dart';
import 'package:lashamezvrishvili_artteo/presentation/scan/scanned_custom.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool isFlashOn = false;
  bool isPortrait = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isPortrait = !isPortrait;
              });
              controller?.flipCamera();
            },
            icon: const Icon(Icons.flip_camera_ios),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiaryContainer
                      .withOpacity(0.3),
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Looking for QR Code',
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(bottom: 40, left: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: TextButton(
                      onPressed: () async {
                        controller?.toggleFlash();

                        setState(() {
                          isFlashOn = !isFlashOn;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isFlashOn
                                ? Icons.flash_on_outlined
                                : Icons.flash_off_outlined,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code == null) return;

      if (scanData.code!.startsWith('http')) {
        await launchURL(context, scanData.code!);
        return;
      }

      if (scanData.code!.startsWith('tel')) {
        await launchPhone(scanData.code!);
        return;
      }

      controller.pauseCamera();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ScannedDataScreen(
          barcode: scanData,
          controller: controller,
        ),
      ));
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
