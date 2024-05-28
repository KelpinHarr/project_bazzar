import 'dart:io';
import 'package:project_bazzar/admin/qrScanOverlay.dart';
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
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 100.0),
              child: QrScanOverlay(overlaySize: 300),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Scan a code',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      activePage: 'Scan QR Top Up',
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
        _isNavigated = true;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TopUp(scanResult: result!)),
        ).then((_) {
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
