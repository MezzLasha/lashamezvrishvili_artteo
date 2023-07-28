import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannedDataScreen extends StatelessWidget {
  const ScannedDataScreen(
      {super.key, required this.barcode, required this.controller});

  final Barcode? barcode;
  final QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller!.resumeCamera();
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Scanned Data'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Center(
                child: TextFormField(
              maxLines: null,
              initialValue: barcode?.code,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Scanned Data',
              ),
            )),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: barcode?.code ?? ''));
            },
            child: const Icon(Icons.copy),
          )),
    );
  }
}
