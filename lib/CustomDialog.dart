import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  // final String content;
  final Widget icon;
  final String actionText;
  final VoidCallback onPressed;

  const CustomDialog({super.key,
    required this.title,
    // required this.content,
    required this.icon,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350.0,
        ), // Set maximum width
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevent dialog from growing too large
            children: [
              Center(child: icon),
              const SizedBox(height: 16.0), // Add spacing between icon and text
              Center(
                child: Text(title, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: onPressed,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green.withOpacity(0.2)), // Set background color with opacity
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
                child: Text(actionText, style: const TextStyle(color: Colors.green, fontSize: 16.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
