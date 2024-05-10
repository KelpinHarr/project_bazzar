import 'dart:io';
import 'package:project_bazzar/admin/topUp.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/admin/navbarv2.dart';

class QrTopUp extends StatefulWidget {
  const QrTopUp({super.key});

  @override
  _QrTopUpState createState() => _QrTopUpState();
}

class _QrTopUpState extends State<QrTopUp> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavbarAdminv2(
      key: GlobalKey(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                  'Barcode Type: ${result!.format.name}   Data: ${result!.code}')
                  : const Text('Scan a code'),
            ),
          )
        ],
      ),
      activePage: 'Scan QR',
    );
  }

  bool _isNavigated = false;
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null && !_isNavigated) {
        _isNavigated = true; // Tandai bahwa navigasi sudah dilakukan
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TopUp()),
        ).then((_) {
          // Dispose controller after returning from TopUp page
          controller.dispose();
          setState(() {
            result = null;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
