import 'package:flutter/material.dart';

class Topup extends StatelessWidget {
  final String id;
  final DateTime date;
  final String buyer;
  final double totalAmount;

  const Topup({super.key,
    required this.id,
    required this.date,
    required this.buyer,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Set rounded corners
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text vertically within row
              children: [
                Text(
                  buyer,
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: Color(0xff0A2B4E),
                      fontWeight: FontWeight.w900
                  ),
                ),
                const Spacer(), // Add space between ID and price
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Rp$totalAmount',
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 4.0), // Spacing between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date and Time
                Text(
                  '${date.day} ${_getMonthName(date.month)} ${date.year}, ${_formatTime(date.hour, date.minute)}',
                  style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xff0A2B4E)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  String _formatTime(int hour, int minute) {
    String formattedHour = hour.toString().padLeft(2, '0');
    String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute';
  }
}