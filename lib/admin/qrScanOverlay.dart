import 'package:flutter/material.dart';
import 'package:project_bazzar/admin/qrScanOverlayPainter.dart';

class QrScanOverlay extends StatelessWidget {
  final double overlaySize;

  QrScanOverlay({this.overlaySize = 300});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: QrScanOverlayPainter(),
        child: Container(
          width: overlaySize,
          height: overlaySize,
        ),
      ),
    );
  }
}