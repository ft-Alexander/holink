import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/parish/financial/view/financial_reports.dart';
import 'package:holink/features/parish/financial/services/financial_record_tx.dart';
import 'package:holink/features/parish/financial/services/financial_edit_record.dart';
import 'package:holink/features/parish/financial/model/transaction.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<List<Transaction>> futureTransactions;
  int? selectedEmployeeId;
  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;
  String? selectedTransactionType;
  String? selectedTransactionCategory;

  @override
  void initState() {
    super.initState();
    futureTransactions = fetchTransactions();
  }

  Future<List<Transaction>> fetchTransactions() async {
    localhost localhostInstance = localhost();
    final url = 'http://${localhostInstance.ipServer}/dashboard/myfolder/finance/getTransactions.php';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['success']) {
        List<Transaction> transactions = (responseBody['transactions'] as List)
            .map((data) => Transaction.fromJson(data))
            .where((transaction) => transaction.archive_status == 'display')
            .toList();

        if (selectedEmployeeId != null) {
          transactions = transactions
              .where((transaction) => transaction.par_id == selectedEmployeeId)
              .toList();
        }

        if (selectedYear != null) {
          transactions = transactions
              .where((transaction) => transaction.date.year == selectedYear)
              .toList();
        }

        if (selectedMonth != null) {
          transactions = transactions
              .where((transaction) => transaction.date.month == selectedMonth)
              .toList();
        }

        if (selectedDay != null) {
          transactions = transactions
              .where((transaction) => transaction.date.day == selectedDay)
              .toList();
        }

        if (selectedTransactionType != null) {
          transactions = transactions
              .where((transaction) => transaction.type == selectedTransactionType)
              .toList();
        }

        if (selectedTransactionCategory != null) {
          transactions = transactions
              .where((transaction) =>
                  transaction.transaction_category == selectedTransactionCategory)
              .toList();
        }

        // Sort transactions by transaction_id in descending order
        transactions.sort((a, b) => (b.transaction_id ?? 0).compareTo(a.transaction_id ?? 0));

        return transactions;
      } else {
        throw Exception('Failed to load transactions: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to load transactions: ${response.reasonPhrase}');
    }
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int? employeeId;
        int? year;
        int? month;
        int? day;
        String? transactionType;
        String? transactionCategory;

        return AlertDialog(
          title: const Text('Filter Transactions'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Employee ID'),
                  onChanged: (value) {
                    employeeId = int.tryParse(value);
                  },
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Year'),
                  items: List.generate(
                    100,
                    (index) => DropdownMenuItem(
                      value: DateTime.now().year - index,
                      child: Text((DateTime.now().year - index).toString()),
                    ),
                  ),
                  onChanged: (value) {
                    year = value;
                  },
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Month'),
                  items: List.generate(
                    12,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text(DateFormat.MMMM().format(DateTime(0, index + 1))),
                    ),
                  ),
                  onChanged: (value) {
                    month = value;
                  },
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Day'),
                  items: List.generate(
                    31,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text((index + 1).toString()),
                    ),
                  ),
                  onChanged: (value) {
                    day = value;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Transaction Type'),
                  items: ['Income', 'Expense'].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    transactionType = value;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Transaction Category'),
                  items: [
                    'Mass Collection',
                    'Mass Offering',
                    'Sacramental Collection',
                    'Sacramental Offering',
                    'Special Event Collection',
                    'Special Event Offering',
                    'Fund Raising',
                    'Donation',
                    'Communication Expense',
                    'Electricity Bill',
                    'Water Bill',
                    'Office Supply',
                    'Transportation',
                    'Salary',
                    'SSS',
                    'PhilHealth',
                    'Social Service / Charity',
                    'Food',
                    'Decorso Sustento-PP / GP',
                    'Other Parish Expenses'
                  ].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    transactionCategory = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedEmployeeId = null;
                  selectedYear = null;
                  selectedMonth = null;
                  selectedDay = null;
                  selectedTransactionType = null;
                  selectedTransactionCategory = null;
                  futureTransactions = fetchTransactions();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedEmployeeId = employeeId;
                  selectedYear = year;
                  selectedMonth = month;
                  selectedDay = day;
                  selectedTransactionType = transactionType;
                  selectedTransactionCategory = transactionCategory;
                  futureTransactions = fetchTransactions();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTopNavBar(),
      ),
      body: Column(
        children: [
          _buildButtons(),
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

  Widget _buildButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ElevatedButton(
            onPressed: _openFilterDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
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
              'Filter',
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
    if (transaction.archive_status != 'display') {
      return SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff904410)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0,
        child: ListTile(
          leading: const Icon(Icons.receipt_long, color: Color(0xffB37840)),
          title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('MMMM dd, yyyy').format(transaction.date)),
              _buildTransactionTag(transaction),
            ],
          ),
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

  Widget _buildTransactionTag(Transaction transaction) {
    Color tagColor = transaction.transaction_category == 'Income' ? Colors.green : Colors.red;
    String tagText = transaction.transaction_category == 'Income' ? 'Income' : 'Expense';

    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        tagText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14.0, // Same size as the font size of the date
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _archiveRecord(BuildContext context, Transaction transaction) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Archive'),
          content: const Text('Are you sure you want to archive this record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      localhost localhostInstance = localhost();
      try {
        final response = await http.post(
          Uri.parse('http://${localhostInstance.ipServer}/dashboard/myfolder/finance/archiveStatus.php'),
          body: json.encode(transaction.toMap()),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Record archived successfully')),
          );
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TransactionsPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to archive record: ${response.statusCode}')),
          );
          throw Exception('Failed to archive record');
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error archiving record: $error')),
        );
        throw error;
      }
    }
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
                _buildDetailRow('Transaction ID:', transaction.transaction_id.toString()),
                _buildDetailRow('Employee ID:', transaction.par_id.toString()),
                _buildDetailRow('Transaction Category:', transaction.transaction_category),
                _buildDetailRow('Transaction Type:', transaction.type),
                if (transaction.sacramental_type != null && transaction.sacramental_type!.isNotEmpty)
                  _buildDetailRow('Sacramental Type:', transaction.sacramental_type!),
                if (transaction.special_event_type != null && transaction.special_event_type!.isNotEmpty)
                  _buildDetailRow('Special Event Type:', transaction.special_event_type!),
                _buildDetailRow('Date:', DateFormat('MMMM dd, yyyy').format(transaction.date)),
                _buildDetailRow('Amount:', 'P ${transaction.amount}'),
                _buildDetailRow('Details:', transaction.description),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _archiveRecord(context, transaction);
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => EditFinancialTransactionPage(transaction: transaction)),
                        );
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
