// ignore_for_file: unnecessary_null_comparison

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
  int? selectedDay;
  String? selectedStatus;
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  String selectedReportType = 'daily'; // Default report type
  DateTime? selectedDate;

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

    try {
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

            // Sort reports by report_id in descending order (latest first)
            reports.sort((a, b) {
              final aId = a['report_id'];
              final bId = b['report_id'];
              if (aId == null && bId == null) return 0;
              if (aId == null) return 1;
              if (bId == null) return -1;
              return bId.compareTo(aId);
            });

            isLoading = false;
          });
        } else {
          throw Exception('Failed to load reports: ${responseBody['message']}');
        }
      } else {
        throw Exception('Failed to load reports: ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      print('Error fetching reports: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _applyDailyFilters() {
    try {
      if (selectedYear != null) {
        reports = reports.where((report) {
          DateTime? reportDate;
          try {
            reportDate = DateFormat('MMMM d, yyyy').parse(report['date']);
          } catch (e) {
            try {
              reportDate = DateFormat('MMMM yyyy').parse(report['date']);
            } catch (e) {
              return false;
            }
          }
          return reportDate.year == selectedYear;
        }).toList();
      }

      if (selectedMonth != null) {
        reports = reports.where((report) {
          DateTime? reportDate;
          try {
            reportDate = DateFormat('MMMM d, yyyy').parse(report['date']);
          } catch (e) {
            try {
              reportDate = DateFormat('MMMM yyyy').parse(report['date']);
            } catch (e) {
              return false;
            }
          }
          final reportMonth = DateFormat('MMMM').format(reportDate);
          return reportMonth == selectedMonth;
        }).toList();
      }

      if (selectedDay != null) {
        reports = reports.where((report) {
          DateTime? reportDate;
          try {
            reportDate = DateFormat('MMMM d, yyyy').parse(report['date']);
          } catch (e) {
            try {
              reportDate = DateFormat('MMMM yyyy').parse(report['date']);
            } catch (e) {
              return false;
            }
          }
          final reportDay = DateFormat('d').format(reportDate);
          return int.parse(reportDay) == selectedDay;
        }).toList();
      }

      if (selectedStatus != null) {
        reports = reports.where((report) => report['status'] == selectedStatus).toList();
      }
    } catch (e, stackTrace) {
      print('Error applying daily filters: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _applyWeeklyFilters() {
    try {
      if (startDate != null || endDate != null) {
        reports = reports.where((report) {
          DateTime? reportDate;
          try {
            reportDate = DateFormat('MMMM d, yyyy').parse(report['date']);
          } catch (e) {
            try {
              reportDate = DateFormat('MMMM yyyy').parse(report['date']);
            } catch (e) {
              return false;
            }
          }

          if (startDate != null && endDate != null) {
            return reportDate.isAfter(startDate!.subtract(const Duration(days: 1))) &&
                  reportDate.isBefore(endDate!.add(const Duration(days: 1)));
          } else if (startDate != null) {
            return reportDate.isAfter(startDate!.subtract(const Duration(days: 1)));
          } else if (endDate != null) {
            return reportDate.isBefore(endDate!.add(const Duration(days: 1)));
          }
          return false;
        }).toList();
      }

      if (selectedStatus != null) {
        reports = reports.where((report) => report['status'] == selectedStatus).toList();
      }
    } catch (e, stackTrace) {
      print('Error applying weekly filters: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _applyMonthlyFilters() {
    try {
      if (selectedYear != null) {
        reports = reports.where((report) {
          final reportDate = DateFormat('MMMM yyyy').parse(report['date']);
          return reportDate.year == selectedYear;
        }).toList();
      }

      if (selectedMonth != null) {
        reports = reports.where((report) {
          final reportDate = DateFormat('MMMM yyyy').parse(report['date']);
          final reportMonth = DateFormat('MMMM').format(reportDate);
          return reportMonth == selectedMonth;
        }).toList();
      }

      if (selectedStatus != null) {
        reports = reports.where((report) => report['status'] == selectedStatus).toList();
      }
    } catch (e, stackTrace) {
      print('Error applying monthly filters: $e');
      print('Stack trace: $stackTrace');
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
          _buildReportTypeButtons(), // Add report type buttons
          _buildGenerateAndFilterButtons(),
          Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildReportList()),
        ],
      ),
      bottomNavigationBar: BottomNavBarParish(
        selectedIndex: _selectedIndexBotNav,
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

  Widget _buildReportTypeButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildReportTypeButton('Daily', 'daily'),
          _buildReportTypeButton('Weekly', 'weekly'),
          _buildReportTypeButton('Monthly', 'monthly'),
        ],
      ),
    );
  }

  Widget _buildReportTypeButton(String label, String type) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedReportType = type;
        });
        _fetchReports(); // Fetch reports for the selected type
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedReportType == type ? Colors.blue : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        textStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
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
        if (selectedReportType == 'daily') {
          return AlertDialog(
            title: const Text('Select Date'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                onDateChanged: (DateTime date) {
                  setState(() {
                    selectedDate = date;
                    print('Selected Date: $selectedDate'); // Debugging statement
                  });
                },
              ),
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
        } else if (selectedReportType == 'weekly') {
          return AlertDialog(
            title: const Text('Select Week Range'),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('Start Date'),
                      trailing: TextButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setState(() {
                              startDate = picked;
                              print('Selected Start Date: $startDate'); // Debugging statement
                            });
                          }
                        },
                        child: Text(startDate != null
                            ? DateFormat('MMMM d, yyyy').format(startDate!)
                            : 'Select Date'),
                      ),
                    ),
                    ListTile(
                      title: const Text('End Date'),
                      trailing: TextButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: endDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setState(() {
                              endDate = picked;
                              print('Selected End Date: $endDate'); // Debugging statement
                            });
                          }
                        },
                        child: Text(endDate != null
                            ? DateFormat('MMMM d, yyyy').format(endDate!)
                            : 'Select Date'),
                      ),
                    ),
                  ],
                ),
              ),
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
        } else {
          return AlertDialog(
            title: const Text('Select Month and Year'),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
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
                          print('Selected Month: $selectedMonth'); // Debugging statement
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
                          print('Selected Year: $selectedYear'); // Debugging statement
                        });
                      },
                    ),
                  ],
                ),
              ),
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
        }
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (selectedReportType == 'daily') {
          return _buildDailyFilterDialog(context);
        } else if (selectedReportType == 'weekly') {
          return _buildWeeklyFilterDialog(context);
        } else {
          return _buildMonthlyFilterDialog(context);
        }
      },
    );
  }

  Widget _buildDailyFilterDialog(BuildContext context) {
    String? filterMonth;
    int? filterDay;
    int? filterYear;
    String? filterStatus;

    return AlertDialog(
      title: const Text('Filter Daily Reports'),
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
            decoration: const InputDecoration(labelText: 'Select Day'),
            items: List<int>.generate(31, (index) => index + 1).map((int day) {
              return DropdownMenuItem<int>(
                value: day,
                child: Text(day.toString()),
              );
            }).toList(),
            onChanged: (value) {
              filterDay = value;
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Select Year'),
            items: List<int>.generate(50, (index) => 2024 - index).map((int year) {
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
              selectedDay = null;
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
              selectedDay = filterDay;
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
  }

  Widget _buildWeeklyFilterDialog(BuildContext context) {
    DateTime? filterStartDate;
    DateTime? filterEndDate;
    String? filterStatus;

    return AlertDialog(
      title: const Text('Filter Weekly Reports'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Start Date'),
            trailing: TextButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: filterStartDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    filterStartDate = picked;
                  });
                }
              },
              child: Text(filterStartDate != null
                  ? DateFormat('MMMM d, yyyy').format(filterStartDate)
                  : 'Select Date'),
            ),
          ),
          ListTile(
            title: const Text('End Date'),
            trailing: TextButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: filterEndDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    filterEndDate = picked;
                  });
                }
              },
              child: Text(filterEndDate != null
                  ? DateFormat('MMMM d, yyyy').format(filterEndDate)
                  : 'Select Date'),
            ),
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
              startDate = null;
              endDate = null;
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
              startDate = filterStartDate;
              endDate = filterEndDate;
              selectedStatus = filterStatus;
              _fetchReports();
            });
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildMonthlyFilterDialog(BuildContext context) {
    String? filterMonth;
    int? filterYear;
    String? filterStatus;

    return AlertDialog(
      title: const Text('Filter Monthly Reports'),
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
            items: List<int>.generate(50, (index) => 2024 - index).map((int year) {
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
  }

  Future<void> _generateReport() async {
    print('Generating report...'); // Debugging statement
    print('Selected Report Type: $selectedReportType'); // Debugging statement
    print('Selected Date: $selectedDate'); // Debugging statement
    print('Start Date: $startDate'); // Debugging statement
    print('End Date: $endDate'); // Debugging statement

    if (selectedReportType == 'daily' && selectedDate == null) {
      print('Daily report selected but no date provided.');
      return;
    }
    if (selectedReportType == 'weekly' && (startDate == null || endDate == null)) {
      print('Weekly report selected but start or end date not provided.');
      return;
    }
    if (selectedReportType == 'monthly' && (selectedMonth == null || selectedYear == null)) {
      print('Monthly report selected but month or year not provided.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
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

          // Filter transactions for the daily report
          if (selectedReportType == 'daily') {
            transactions = transactions.where((transaction) {
              return DateFormat('yyyy-MM-dd').format(transaction.date) == DateFormat('yyyy-MM-dd').format(selectedDate!);
            }).toList();
          }

          final reportData = _consolidateReportData(transactions);

          await _saveReport(reportData);

          setState(() {
            reports.insert(0, reportData); // Insert the new report at the top
            // Sort reports by report_id in descending order (latest first)
            reports.sort((a, b) {
              final aId = a['report_id'];
              final bId = b['report_id'];
              if (aId == null && bId == null) return 0;
              if (aId == null) return 1;
              if (bId == null) return -1;
              return bId.compareTo(aId);
            });

            isLoading = false;
          });

          _fetchReports(); // Refresh reports list after generating a new report
        } else {
          throw Exception('Failed to load transactions: ${responseBody['message']}');
        }
      } else {
        throw Exception('Failed to load transactions: ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      print('Error generating report: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        isLoading = false;
      });
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
      if (selectedReportType == 'daily' &&
          DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(selectedDate!)) {
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
      } else if (selectedReportType == 'weekly' &&
          date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate!.add(const Duration(days: 1)))) {
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
      } else if (selectedReportType == 'monthly' &&
          DateFormat('MMMM yyyy').format(date) == '$selectedMonth $selectedYear') {
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

    print('Report Data:'); // Debugging statement
    print('Gross Income: $grossIncome'); // Debugging statement
    print('Gross Expenses: $grossExpenses'); // Debugging statement
    print('Net Deficit: $netDeficit'); // Debugging statement

    return {
      'par_id': 1,
      'parish_name': 'St. James the Greater Parish',
      'date': selectedReportType == 'daily'
          ? DateFormat('MMMM d, yyyy').format(selectedDate!)
          : selectedReportType == 'weekly'
              ? '${DateFormat('MMMM d, yyyy').format(startDate!)} to ${DateFormat('MMMM d, yyyy').format(endDate!)}'
              : '$selectedMonth $selectedYear',
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
      'report_type': selectedReportType, // Add report type here
      'parishioners_access': 'hidden', // default value
    };
  }

  Future<void> _saveReport(Map<String, dynamic> reportData) async {
    try {
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
    } catch (e, stackTrace) {
      print('Error saving report: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Widget _buildReportList() {
    // Filter reports based on the selected report type (daily, weekly, monthly)
    List<Map<String, dynamic>> filteredReports = reports.where((report) {
      return report['report_type'] == selectedReportType;
    }).toList();

    return ListView.builder(
      itemCount: filteredReports.length,
      itemBuilder: (context, index) {
        return ReportCard(
          report: filteredReports[index],
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
