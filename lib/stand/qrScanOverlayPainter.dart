import 'package:flutter/material.dart';

class QrScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintRed = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Paint paintGreen = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Paint paintYellow = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Paint paintBlue = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final double cornerSize = 30.0;
    final double radius = 15.0;

    // Top left corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      -3.14,
      1.57,
      false,
      paintRed,
    );
    canvas.drawLine(Offset(radius, 0), Offset(cornerSize, 0), paintRed);
    canvas.drawLine(Offset(0, radius), Offset(0, cornerSize), paintRed);

    // Top right corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width - radius, radius), radius: radius),
      -1.57,
      1.57,
      false,
      paintYellow,
    );
    canvas.drawLine(Offset(size.width - radius, 0), Offset(size.width - cornerSize, 0), paintYellow);
    canvas.drawLine(Offset(size.width, radius), Offset(size.width, cornerSize), paintYellow);

    // Bottom left corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, size.height - radius), radius: radius),
      1.57,
      1.57,
      false,
      paintGreen,
    );
    canvas.drawLine(Offset(0, size.height - radius), Offset(0, size.height - cornerSize), paintGreen);
    canvas.drawLine(Offset(radius, size.height), Offset(cornerSize, size.height), paintGreen);

    // Bottom right corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width - radius, size.height - radius), radius: radius),
      0,
      1.57,
      false,
      paintBlue,
    );
    canvas.drawLine(Offset(size.width - radius, size.height), Offset(size.width - cornerSize, size.height), paintBlue);
    canvas.drawLine(Offset(size.width, size.height - radius), Offset(size.width, size.height - cornerSize), paintBlue);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
