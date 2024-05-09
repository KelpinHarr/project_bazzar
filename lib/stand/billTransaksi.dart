import 'package:flutter/material.dart';
import 'package:project_bazzar/Transaction.dart';

class BillTransaksi extends StatelessWidget {
  final Transaction transaction;
  const BillTransaksi({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataTable(
          columnSpacing: 20.0, // Adjust column spacing
          columns: const [
            DataColumn(
              label: Text(
                'Nama',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Qty',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Harga',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: transaction.items.map((item) => DataRow(
            cells: [
              DataCell(
                Text(item.name),
              ),
              DataCell(
                Text(item.quantity.toString()),
              ),
              DataCell(
                Text('Rp${item.price}'),
              ),
              DataCell(
                Text('Rp${item.price * item.quantity}'),
              ),
            ],
          )).toList(),
        ),
        const SizedBox(height: 16.0), // Spacing before total
        // Total Amount with Divider
        Divider(thickness: 1.0, color: Colors.grey),
        const SizedBox(height: 16.0),
        buildTotalRow('Total Qty:', '${transaction.totalQty}'),
        const SizedBox(height: 16.0),
        buildTotalRow(
          'Total:',
          'Rp${transaction.totalAmount}',
          textColor: Colors.green,
        ),
      ],
    );
  }

  Widget buildTotalRow(String label, String value, {Color textColor = Colors.black}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              label,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
