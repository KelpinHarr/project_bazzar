import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/navbarv2.dart';

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                // Text(
                //   '',
                //   style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff0A2B4E)),
                // ),
                const SizedBox(height: 8.0),
                DataTable(
                  // Define columns for items table
                  columns: [
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Nama',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Qty',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Harga',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: transaction.items.map((item) => DataRow(
                    cells: [
                      DataCell(
                        Expanded(
                          child: Text(item.name),
                        ),
                      ),
                      DataCell(
                        Expanded(
                          child: Text(item.quantity.toString()),
                        ),
                      ),
                      DataCell(
                        Expanded(
                          child: Text('Rp${item.price}'),
                        ),
                      ),
                      DataCell(
                        Expanded(
                          child: Text('Rp${item.price * item.quantity}'),
                        ),
                      ),
                    ],
                  )).toList(),
                ),
                const SizedBox(height: 16.0), // Spacing before total
                // Total Amount with Divider
                const Divider(thickness: 1.0, color: Colors.grey),
                const SizedBox(height: 16.0),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight, // Align text to the right
                            child: Text(
                              'Total Qty: ',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight, // Align text to the right
                          child: Text(
                            '${transaction.totalQty}',
                            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight, // Align text to the right
                            child: const Text(
                              'Total: ',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight, // Align text to the right
                          child: Text(
                            'Rp${transaction.totalAmount}',
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        activePage: 'Detil transaksi'
    );
  }

  Widget _buildTransactionInfo(BuildContext context, String value, String label) {
    Color textColor;
    if (value == 'Completed') {
      textColor = Colors.green;
    } else if (value == 'Canceled') {
      textColor = Colors.red;
    } else {
      // Gunakan warna default untuk nilai lainnya
      textColor = Colors.black; // Atau warna lain sesuai kebutuhan
    }

    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xff0A2B4E)),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 16.0,
                color: textColor,
                fontWeight: FontWeight.w900
            ),
          ),
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
  final double totalQty;

  const Transaction({
    required this.id,
    required this.date,
    required this.stand,
    required this.buyerId,
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.totalQty,
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
