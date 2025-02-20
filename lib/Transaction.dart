import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/detailTransaksi.dart';

class TransactionItem {
  String name;
  int quantity;
  double price;

   TransactionItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
  
  factory TransactionItem.fromMap(Map<String, dynamic> data) {
    return TransactionItem(
      name: data['name'] ?? '',
      quantity: data['quantity'] is int ? data['quantity'] : int.tryParse(data['quantity'].toString()) ?? 0,
      price: data['price'] is double ? data['price'] : double.tryParse(data['price'].toString()) ?? 0.0,
    );
  }
}

class Transactions extends StatelessWidget {
  final String id;
  final String name;
  final DateTime date;
  final String stand;
  final String buyerId;
  final String status;
  final List<TransactionItem> items;
  final double totalAmount;
  final double totalQty;

  const Transactions({
    required this.id,
    required this.name,
    required this.date,
    required this.stand,
    required this.buyerId,
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.totalQty,
  });

  factory Transactions.fromMap(String id, Map<String, dynamic> data) {
    List<TransactionItem> items = (data['items'] as List).map((item) {
      return TransactionItem.fromMap(item);
    }).toList();

    return Transactions(
      id: id,
      name: data['name'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      stand: data['stand'] ?? '',
      buyerId: data['buyerId'] ?? '',
      status: data['status'] ?? '',
      items: items,
      totalAmount: data['totalAmount'] is int
          ? (data['totalAmount'] as int).toDouble()
          : double.parse(data['totalAmount'].toString()),
      totalQty: data['totalQty'] is int
          ? (data['totalQty'] as int).toDouble()
          : double.parse(data['totalQty'].toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      // color: const Color(0xffAAD4FF),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), // Set rounded corners
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction ID (increased font size)
                Text(
                  id,
                  style: const TextStyle(
                      fontSize: 22.0,
                      color: Color(0xff0A2B4E),
                      fontWeight: FontWeight.w900),
                ),
                const Spacer(), // Add space between ID and price

                // Price (increased font size, margin right)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Rp$totalAmount',
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
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
                      fontSize: 18.0, color: const Color(0xff0A2B4E)),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailTransaksi(
                                transaction: Transactions(
                                    id: id,
                                    name: name,
                                    date: date,
                                    stand: stand,
                                    buyerId: buyerId,
                                    status: status,
                                    items: items,
                                    totalAmount: totalAmount,
                                    totalQty: totalQty),
                                name: name,
                              )),
                    );
                  },
                  child: const Text(
                    'Lihat detail >',
                    style: TextStyle(
                        color: Color(0xff0A2B4E),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                    ),
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
