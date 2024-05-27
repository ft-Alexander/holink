import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/financial/view/financial_reports.dart';
import 'package:holink/features/financial/services/financial_record_tx.dart';
import 'package:holink/features/financial/model/transaction.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<List<Transaction>> futureTransactions;

  @override
  void initState() {
    super.initState();
    futureTransactions = fetchTransactions();
  }

  Future<List<Transaction>> fetchTransactions() async {
    localhost localhostInstance = localhost();
    final url = 'http://${localhostInstance.ipServer}/dashboard/myfolder/getTransactions.php'; // Replace with your server URL

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['success']) {
        List<Transaction> transactions = (responseBody['transactions'] as List)
            .map((data) => Transaction.fromJson(data))
            .toList();
        return transactions;
      } else {
        throw Exception('Failed to load transactions: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to load transactions: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTopNavBar(),
      ),
      body: Column(
        children: [
          _buildRecordButton(), // Add the Record Transaction button
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: futureTransactions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No transactions found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return TransactionCard(transaction: snapshot.data![index]);
                    },
                  );
                }
              },
            ),
          ),
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
          subtitle: Text(DateFormat('MMMM dd, yyyy').format(transaction.date)),
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
                Center(
                  child: Text(
                    transaction.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildDetailRow('Transaction ID:', transaction.par_id.toString()),
                _buildDetailRow('Employee ID:', transaction.par_id.toString()),
                _buildDetailRow('Transaction Type:', transaction.type),
                if (transaction.sacramental_type != null && transaction.sacramental_type!.isNotEmpty)
                  _buildDetailRow('Sacramental Type:', transaction.sacramental_type!),
                if (transaction.special_event_type != null && transaction.special_event_type!.isNotEmpty)
                  _buildDetailRow('Special Event Type:', transaction.special_event_type!),
                _buildDetailRow('Date:', DateFormat('MMMM dd, yyyy').format(transaction.date)),
                _buildDetailRow('Amount:', 'P ${transaction.amount}'),
                _buildDetailRow('Details:', transaction.description),
                if (transaction.purpose != null && transaction.purpose!.isNotEmpty)
                  _buildDetailRow('Purpose:', transaction.purpose!),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Archive action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: const Text(
                        'Archive',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Edit action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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