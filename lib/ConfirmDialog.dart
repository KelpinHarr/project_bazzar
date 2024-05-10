import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final Widget icon;
  final String message;
  final String mode;
  final VoidCallback onDeletePressed;
  final VoidCallback onCancelPressed;

  const ConfirmDialog({
    required this.title,
    required this.icon,
    required this.message,
    required this.mode,
    required this.onDeletePressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: const Color(0xff0A2B4E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: icon),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onDeletePressed,
                  child: Text(mode, style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                TextButton(
                  onPressed: onCancelPressed,
                  child: const Text("Kembali", style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}