import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:holink/features/parish/financial/model/transaction.dart';

class ViewTransactionPopup extends StatelessWidget {
  final Transaction transaction;

  const ViewTransactionPopup({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              transaction.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            _buildDetailRow(
                'Transaction ID:', transaction.transaction_id.toString()),
            _buildDetailRow('Employee ID:', transaction.par_id.toString()),
            _buildDetailRow('Transaction Type:', transaction.type),
            _buildDetailRow(
                'Date:', DateFormat('MMMM d, y').format(transaction.date)),
            _buildDetailRow('Amount:', 'P ${transaction.amount}'),
            _buildDetailRow('Details:', transaction.description),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Archive action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Archive'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Edit action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
