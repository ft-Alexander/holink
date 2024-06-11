import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/parish/dashboard/view/dashboard.dart';
import 'package:holink/features/parish/financial/services/financial_view_report.dart';
import 'package:holink/features/parish/profile/view/profile.dart';
import 'package:holink/features/parish/scheduling/view/scheduling.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/parish/financial/view/financial_transactions.dart';
import 'package:holink/features/parish/financial/model/transaction.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Map<String, dynamic>> reports = [];
  int? selectedYear;
  String? selectedMonth;
  String? selectedStatus;
  bool isLoading = false;

  int _selectedIndexBotNav = 2;

  final Map<int, Widget> bottomNavBarRoutes = {
    0: const Dashboard(),
    1: const Scheduling(),
    2: const TransactionsPage(),
    3: const ProfileScreen(),
  };

  void _navigateTo(int index, BuildContext context, Map<int, Widget> routes) {
    if (routes.containsKey(index)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routes[index]!),
      );
    }
  }

  void _onBotNavSelected(int index, BuildContext context) {
    setState(() {
      _selectedIndexBotNav = index;
    });
    _navigateTo(index, context, bottomNavBarRoutes);
  }

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      isLoading = true;
    });

    localhost localhostInstance = localhost();
    final url =
        'http://${localhostInstance.ipServer}/dashboard/myfolder/finance/getReports.php';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['success']) {
        setState(() {
          reports = List<Map<String, dynamic>>.from(responseBody['reports'])
              .where((report) => report['archive_status'] == 'display')
              .toList();

          // Apply filters
          if (selectedYear != null) {
            reports = reports.where((report) {
              final reportYear =
                  DateFormat('MMMM yyyy').parse(report['date']).year;
              return reportYear == selectedYear;
            }).toList();
          }

          if (selectedMonth != null) {
            reports = reports.where((report) {
              final reportMonth = DateFormat('MMMM')
                  .format(DateFormat('MMMM yyyy').parse(report['date']));
              return reportMonth == selectedMonth;
            }).toList();
          }

          if (selectedStatus != null) {
            reports = reports
                .where((report) => report['status'] == selectedStatus)
                .toList();
          }

          // Sort reports by report_id in descending order (latest first)
          reports.sort((a, b) => b['report_id'].compareTo(a['report_id']));

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reports: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to load reports: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _buildTopNavBar(),
      ),
      body: Column(
        children: [
          _buildGenerateAndFilterButtons(),
          Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildReportList()),
        ],
      ),
      bottomNavigationBar: BottomNavBarParish(
        selectedIndex: 2,
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TransactionsPage()),
            );
          },
          child: const Text(
            'TRANSACTIONS',
            style: TextStyle(
              color: Color(0xff797979),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          children: [
            TextButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text(
                'REPORTS',
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
      ],
    );
  }

  Widget _buildGenerateAndFilterButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              _showGenerateReportDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            child: const Text(
              'Generate Report',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showFilterDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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

  void _showGenerateReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month and Year'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Month'),
                items: DateFormat().dateSymbols.MONTHS.map((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Select Year'),
                items: List<int>.generate(50, (index) => 2024 - index)
                    .map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedYear = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _generateReport();
              },
              child: const Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? filterMonth;
        int? filterYear;
        String? filterStatus;

        return AlertDialog(
          title: const Text('Filter Reports'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Month'),
                items: DateFormat().dateSymbols.MONTHS.map((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (value) {
                  filterMonth = value;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Select Year'),
                items: List<int>.generate(50, (index) => 2024 - index)
                    .map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  filterYear = value;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Status'),
                items: ['Accepted', 'Pending', 'Rejected'].map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  filterStatus = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedMonth = null;
                  selectedYear = null;
                  selectedStatus = null;
                  _fetchReports();
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
                  selectedMonth = filterMonth;
                  selectedYear = filterYear;
                  selectedStatus = filterStatus;
                  _fetchReports();
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

  Future<void> _generateReport() async {
    if (selectedMonth == null || selectedYear == null) return;

    setState(() {
      isLoading = true;
    });

    localhost localhostInstance = localhost();
    final url =
        'http://${localhostInstance.ipServer}/dashboard/myfolder/finance/getTransactions.php';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['success']) {
        List<Transaction> transactions = (responseBody['transactions'] as List)
            .map((data) => Transaction.fromJson(data))
            .where((transaction) => transaction.archive_status == 'display')
            .toList();

        final reportData = _consolidateReportData(transactions);

        await _saveReport(reportData);

        setState(() {
          reports.add(reportData);
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load transactions: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to load transactions: ${response.reasonPhrase}');
    }
  }

  Map<String, dynamic> _consolidateReportData(List<Transaction> transactions) {
    double massesFunds = 0.0;
    double massCollections = 0.0;
    double stoleFees = 0.0;
    double otherReceipts = 0.0;

    double communicationExpenses = 0.0;
    double electricityWaterBill = 0.0;
    double officeSupplies = 0.0;
    double transportation = 0.0;
    double salariesWages = 0.0;
    double sssHdmfPhilHealth = 0.0;
    double socialServicesCharities = 0.0;
    double food = 0.0;
    double decorsoSustentoPPGP = 0.0;
    double otherParishExpenses = 0.0;

    for (var transaction in transactions) {
      final date = transaction.date;
      if (DateFormat('MMMM').format(date) == selectedMonth &&
          DateFormat('yyyy').format(date) == selectedYear.toString()) {
        switch (transaction.type) {
          case 'Mass Collection':
          case 'Mass Offering':
            massesFunds += double.parse(transaction.amount);
            break;
          case 'Sacramental Collection':
          case 'Sacramental Offering':
            stoleFees += double.parse(transaction.amount);
            break;
          case 'Special Event Collection':
          case 'Special Event Offering':
            massCollections += double.parse(transaction.amount);
            break;
          case 'Fund Raising':
          case 'Donation':
            otherReceipts += double.parse(transaction.amount);
            break;
          case 'Communication Expense':
            communicationExpenses += double.parse(transaction.amount);
            break;
          case 'Electricity Bill':
          case 'Water Bill':
            electricityWaterBill += double.parse(transaction.amount);
            break;
          case 'Office Supply':
            officeSupplies += double.parse(transaction.amount);
            break;
          case 'Transportation':
            transportation += double.parse(transaction.amount);
            break;
          case 'Salary':
            salariesWages += double.parse(transaction.amount);
            break;
          case 'SSS':
          case 'PhilHealth':
            sssHdmfPhilHealth += double.parse(transaction.amount);
            break;
          case 'Social Service / Charity':
            socialServicesCharities += double.parse(transaction.amount);
            break;
          case 'Food':
            food += double.parse(transaction.amount);
            break;
          case 'Decorso Sustento-PP / GP':
            decorsoSustentoPPGP += double.parse(transaction.amount);
            break;
          case 'Other Parish Expenses':
            otherParishExpenses += double.parse(transaction.amount);
            break;
        }
      }
    }

    double grossIncome =
        massesFunds + massCollections + stoleFees + otherReceipts;
    double grossExpenses = communicationExpenses +
        electricityWaterBill +
        officeSupplies +
        transportation +
        salariesWages +
        sssHdmfPhilHealth +
        socialServicesCharities +
        food +
        decorsoSustentoPPGP +
        otherParishExpenses;
    double netDeficit = grossIncome - grossExpenses;

    return {
      'par_id': 1,
      'parish_name': 'St. James the Greater Parish',
      'date': '$selectedMonth $selectedYear',
      'status': 'Pending',
      'archive_status': 'display',
      'massesFunds': massesFunds.toStringAsFixed(2),
      'massCollections': massCollections.toStringAsFixed(2),
      'stoleFees': stoleFees.toStringAsFixed(2),
      'otherReceipts': otherReceipts.toStringAsFixed(2),
      'grossIncome': grossIncome.toStringAsFixed(2),
      'communicationExpenses': communicationExpenses.toStringAsFixed(2),
      'electricityWaterBill': electricityWaterBill.toStringAsFixed(2),
      'officeSupplies': officeSupplies.toStringAsFixed(2),
      'transportation': transportation.toStringAsFixed(2),
      'salariesWages': salariesWages.toStringAsFixed(2),
      'sssHdmfPhilHealth': sssHdmfPhilHealth.toStringAsFixed(2),
      'socialServicesCharities': socialServicesCharities.toStringAsFixed(2),
      'food': food.toStringAsFixed(2),
      'decorsoSustentoPPGP': decorsoSustentoPPGP.toStringAsFixed(2),
      'otherParishExpenses': otherParishExpenses.toStringAsFixed(2),
      'grossExpenses': grossExpenses.toStringAsFixed(2),
      'totalIncome': grossIncome.toStringAsFixed(2),
      'totalExpenses': grossExpenses.toStringAsFixed(2),
      'netDeficit': netDeficit.toStringAsFixed(2),
    };
  }

  Future<void> _saveReport(Map<String, dynamic> reportData) async {
    localhost localhostInstance = localhost();
    final url =
        'http://${localhostInstance.ipServer}/dashboard/myfolder/finance/saveReport.php';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(reportData),
    );

    if (response.statusCode != 200) {
      final responseBody = json.decode(response.body);
      throw Exception('Failed to save report: ${responseBody['message']}');
    }
  }

  Widget _buildReportList() {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return ReportCard(
          report: reports[index],
        );
      },
    );
  }
}

class ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff904410)), // Border color
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Rounded corners to match container
        ),
        elevation: 0, // Remove the shadow
        child: ListTile(
          leading: const Icon(Icons.receipt_long, color: Color(0xffB37840)),
          title: Text(report['parish_name'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(report['date']),
              Container(
                margin: const EdgeInsets.only(top: 4.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: report['status'] == 'Pending'
                      ? Colors.orange
                      : report['status'] == 'Accepted'
                          ? Colors.green
                          : Colors.red,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  report['status'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          trailing: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailedReportView(report: report)),
              );
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
}
