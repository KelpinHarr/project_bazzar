import 'dart:convert';
import 'dart:io';
import 'package:project_bazzar/Transaction.dart';
import 'package:project_bazzar/admin/qrScanOverlay.dart';
import 'package:project_bazzar/stand/navbarv2.dart';
import 'package:project_bazzar/stand/pageBayar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class QrBayarTransaksi extends StatefulWidget {
  final double totalHarga;
  final String stand_name;
  final List<Transactions> transactions;
  
  const QrBayarTransaksi({super.key, required this.totalHarga, required this.stand_name, required this.transactions});

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
    return NavbarStandv2(
      key: GlobalKey(),
      name: widget.stand_name,
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageBayar(
              scanResult: result!,
              totalHarga: widget.totalHarga,
              stand_name: widget.stand_name,
              transactions: widget.transactions,
            ), // KE KONFIRMASI BAYAR
          ),
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
