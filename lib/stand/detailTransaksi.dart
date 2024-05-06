import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/navbarv2.dart';
import 'package:project_bazzar/student/navbar.dart';

class DetailTransaksi extends StatelessWidget {
  final Transaction transaction;

  const DetailTransaksi({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavbarStandv2(
        key: GlobalKey(),
        body: Scaffold(
            backgroundColor: const Color(0xffF0F0E8),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Info Card
                Card(
                  elevation: 4.0, // Add a slight shadow effect
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Rounded corners
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTransactionInfo(context, transaction.id, 'Nomor Transaksi:'),
                        const SizedBox(height: 8.0),
                        _buildTransactionInfo(context, transaction.date, 'Tanggal:'),
                        const SizedBox(height: 8.0),
                        _buildTransactionInfo(context, transaction.stand, 'Stand:'),
                        const SizedBox(height: 8.0),
                        _buildTransactionInfo(context, transaction.buyerId, 'Pembeli:'),
                        const SizedBox(height: 8.0),
                        _buildTransactionInfo(context, transaction.status, 'Status:'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0), // Spacing after card

                // Items List with Heading
                Text(
                  'Item',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff0A2B4E)),
                ),
                const SizedBox(height: 8.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transaction.items.length,
                  itemBuilder: (context, index) {
                    final item = transaction.items[index];
                    return _buildTransactionItem(context, item.name, item.quantity, item.price);
                  },
                ),
                const SizedBox(height: 16.0), // Spacing before total

                // Total Amount with Divider
                const Divider(thickness: 1.0, color: Colors.grey),
                const SizedBox(height: 16.0),
                _buildTransactionInfo(context, 'Rp ${transaction.totalAmount.toStringAsFixed(2)}', 'Total:'),
              ],
            ),
          ),
        ),
        activePage: 'Detil transaksi'
    );
  }

  Widget _buildTransactionInfo(BuildContext context, String value, String label) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, String name, int quantity, double price) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$name x $quantity',
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        Text(
          'Rp ${price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}

class Transaction {
  final String id;
  final String date;
  final String stand;
  final String buyerId;
  final String status;
  final List<TransactionItem> items;
  final double totalAmount;

  const Transaction({
    required this.id,
    required this.date,
    required this.stand,
    required this.buyerId,
    required this.status,
    required this.items,
    required this.totalAmount,
  });
}

class TransactionItem {
  final String name;
  final int quantity;
  final double price;

  const TransactionItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
