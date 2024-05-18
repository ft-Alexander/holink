import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:holink/features/financial/view/financial_record_tx.dart';
import 'package:holink/features/financial/view/financial_reports.dart';

import 'package:holink/features/financial/controller/transaction_state.dart';
import 'package:holink/features/financial/controller/transaction.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTopNavBar(),
      ),
      body: Column(
        children: [
          _buildRecordButton(),
          Expanded(child: _buildTransactionList(context)),
        ],
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {}); // Reload the transactions page
                },
                child: const Text(
                  'TRANSACTIONS',
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 2.0,
                width: 200.0,
                color: const Color(0xffB37840),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ReportsPage()),
                  );
                },
                child: const Text(
                  'REPORTS',
                  style: TextStyle(
                    color: Color(0xff797979),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 2.0,
                width: 200.0,
                color: Colors.transparent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RecordFinancialTransactionPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            child: const Text(
              'Record Transaction',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    return Consumer<TransactionState>(
      builder: (context, transactionState, child) {
        return ListView.builder(
          itemCount: transactionState.transactions.length,
          itemBuilder: (context, index) {
            return TransactionCard(
              transaction: transactionState.transactions[index],
            );
          },
        );
      },
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff904410)), // Green border
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners to match container
        ),
        elevation: 0, // Remove the shadow
        child: ListTile(
          leading: const Icon(Icons.receipt_long, color: Color(0xffB37840)),
          title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(DateFormat('MMMM dd, yyyy').format(DateTime.parse(transaction.date))),
          trailing: TextButton(
            onPressed: () {
              _showTransactionDetails(context, transaction);
            },
            child: const Text(
              'See Details',
              style: TextStyle(
                color: Color(0xff686868),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(transaction.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildDetailRow('Transaction ID:', transaction.transactionId),
                _buildDetailRow('Employee ID:', transaction.employeeId),
                _buildDetailRow('Transaction Type:', transaction.type),
                if (transaction.sacramentalType != null && transaction.sacramentalType!.isNotEmpty)
                  _buildDetailRow('Sacramental Type:', transaction.sacramentalType!),
                if (transaction.specialEventType != null && transaction.specialEventType!.isNotEmpty)
                  _buildDetailRow('Special Event Type:', transaction.specialEventType!),
                _buildDetailRow('Date:', DateFormat('MMMM dd, yyyy').format(DateTime.parse(transaction.date))),
                _buildDetailRow('Amount:', transaction.amount),
                _buildDetailRow('Description:', transaction.description),
                if (transaction.purpose != null && transaction.purpose!.isNotEmpty)
                  _buildDetailRow('Purpose:', transaction.purpose!),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
