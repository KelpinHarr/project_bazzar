import 'dart:convert';
import 'dart:io';
import 'package:project_bazzar/admin/qrScanOverlay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/admin/navbarv2.dart';

class QrBayarTransaksi extends StatefulWidget {
  const QrBayarTransaksi({super.key});

  @override
  _QrBayarTransaksiState createState() => _QrBayarTransaksiState();
}

class _QrBayarTransaksiState extends State<QrBayarTransaksi> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _isNavigated = false;
  String? barcodeString;
  Map<String, dynamic>? user;
  String? name;

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
      activePage: 'Scan QR Bayar Transaksi',
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        barcodeString = result?.code;
        if (barcodeString != null) {
          user = jsonDecode(barcodeString!);
          name = user?['nama'];
        }
      });

      if (result != null && !_isNavigated && name != null) {
        _isNavigated = true;
        // Navigator.push(
          // context,
          // MaterialPageRoute(
            // builder: (context) => CekSaldo(scanResult: result!), // KE KONFIRMASI BAYAR
          // ),
        // ).then((_) {
        //   controller.dispose();
        //   setState(() {
        //     result = null;
        //   });
        // });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
