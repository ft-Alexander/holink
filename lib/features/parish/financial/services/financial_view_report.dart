import 'package:flutter/material.dart';
import 'package:holink/features/parish/financial/view/financial_reports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:holink/dbConnection/localhost.dart';

class DetailedReportView extends StatelessWidget {
  final Map<String, dynamic> report;

  const DetailedReportView({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Detailed Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      report['parish_name'],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      report['date']!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildStatus(report['status']),
              const SizedBox(height: 16),
              _buildSection('Income / Receipts', [
                _buildDetailRow('a) Masses Fund', report['massesFunds']),
                _buildDetailRow('b) Mass Collections', report['massCollections']),
                _buildDetailRow('c) Stole Fees', report['stoleFees']),
                _buildDetailRow('d) Other Receipts', report['otherReceipts']),
                _buildDetailRow('Gross Income / Receipts', report['totalIncome']),
              ]),
              const SizedBox(height: 16),
              _buildSection('Expenses / Disbursements', [
                _buildDetailRow('a) Communication Expenses', report['communicationExpenses']),
                _buildDetailRow('b) Electricity / Water', report['electricityWaterBill']),
                _buildDetailRow('c) Office Supplies', report['officeSupplies']),
                _buildDetailRow('d) Transportation', report['transportation']),
                _buildDetailRow('e) Salaries / Wages', report['salariesWages']),
                _buildDetailRow('f) SSS / HDMF PhilHealth', report['sssHdmfPhilHealth']),
                _buildDetailRow('g) Social Services / Charities', report['socialServicesCharities']),
                _buildDetailRow('h) Food', report['food']),
                _buildDetailRow('i) Decoroso Sustento-PP / GP', report['decorsoSustentoPPGP']),
                _buildDetailRow('j) Other Parish Expenses', report['otherParishExpenses']),
                _buildDetailRow('Gross Expenses / Disbursements', report['totalExpenses']),
              ]),
              const SizedBox(height: 16),
              _buildSection('Summary as of ${report['date']}', [
                _buildDetailRow('a) Total Income', report['totalIncome']),
                _buildDetailRow('b) Total Expenses', report['totalExpenses']),
                _buildDetailRow('c) Net / Deficit', report['netDeficit']),
              ]),
              const SizedBox(height: 16),
              _buildSignatures(),
              const SizedBox(height: 16),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...rows,
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text('P $value'),
      ],
    );
  }

  Widget _buildStatus(String status) {
    Color statusColor;
    switch (status) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Accepted':
        statusColor = Colors.green;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Status:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignatures() {
    return Column(
      children: [
        const Text(
          'Signees',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSignature('Siemn Ernst Garay', 'Parish Head'),
            _buildSignature('Albert De Hitta', 'Financial Council'),
          ],
        ),
        const SizedBox(height: 16),
        _buildSignature('John Gabriel Buenasalida', 'Parish Secretary'),
      ],
    );
  }

  Widget _buildSignature(String name, String title) {
    return Column(
      children: [
        Text(name),
        Text(title),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    switch (report['status']) {
      case 'Accepted':
        return _buildAcceptedActions(context);
      case 'Pending':
        return _buildPendingActions(context);
      case 'Rejected':
        return _buildRejectedActions(context);
      default:
        return Container();
    }
  }

  Widget _buildAcceptedActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            // Handle download action
          },
          child: const Text(
            'Download File',
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _archiveReport(context);
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
        ElevatedButton(
          onPressed: () {
            // Handle share action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          child: const Text(
            'Share',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            _updateStatus(context, 'Accepted');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          child: const Text(
            'Accept',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _updateStatus(context, 'Rejected');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          child: const Text(
            'Reject',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRejectedActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            _archiveReport(context);
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
        ElevatedButton(
          onPressed: () {
            _editReport(context);
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
    );
  }

  Future<void> _updateStatus(BuildContext context, String status) async {
    localhost localhostInstance = localhost();
    try {  
      final response = await http.post(
        Uri.parse('http://${localhostInstance.ipServer}/dashboard/myfolder/finance/updateStatus.php'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'report_id': report['report_id'], 'status': status}),
      );

      if (response.statusCode == 200) {
        try {
          final responseBody = json.decode(response.body);
          if (responseBody['success']) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Report $status successfully')),
            );
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReportsPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update status: ${responseBody['message']}')),
            );
            throw Exception('Failed to update status: ${responseBody['message']}');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update status: Invalid response format')),
          );
          throw Exception('Failed to update status: Invalid response format');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: ${response.statusCode}')),
        );
        throw Exception('Failed to update status');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $error')),
      );
    }
  }

  Future<void> _archiveReport(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Archive'),
          content: const Text('Are you sure you want to archive this report?'),
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
          Uri.parse('http://${localhostInstance.ipServer}/dashboard/myfolder/finance/archiveReport.php'),
          body: json.encode({'report_id': report['report_id'], 'archive_status': 'archive'}),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report archived successfully')),
          );
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ReportsPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to archive report: ${response.statusCode}')),
          );
          throw Exception('Failed to archive report');
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error archiving report: $error')),
        );
        rethrow;
      }
    }
  }

  void _editReport(BuildContext context) {
    // Implement edit functionality
  }
}
