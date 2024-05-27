import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/financial/view/financial_transactions.dart';
import 'package:holink/features/financial/model/transaction.dart';

class RecordFinancialTransactionPage extends StatefulWidget {
  const RecordFinancialTransactionPage({super.key});

  @override
  _RecordFinancialTransactionPageState createState() => _RecordFinancialTransactionPageState();
}

class _RecordFinancialTransactionPageState extends State<RecordFinancialTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _transactionIdController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedTransactionType;
  String? _selectedSacramentalType;
  String? _selectedSpecialEventType;
  bool _isFormModified = false;

  localhost localhostInstance = localhost();

  @override
  void initState() {
    super.initState();
    _fetchNextTransactionId();
    _employeeIdController.addListener(_onFormChange);
    _amountController.addListener(_onFormChange);
    _titleController.addListener(_onFormChange);
    _descriptionController.addListener(_onFormChange);
    _dateController.addListener(_onFormChange);
    _purposeController.addListener(_onFormChange);
  }

  Future<void> _fetchNextTransactionId() async {
    final url = 'http://${localhostInstance.ipServer}/dashboard/myfolder/getCurrentTransactionId.php'; // Replace with your server URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['success']) {
        setState(() {
          _transactionIdController.text = responseBody['next_transaction_id'].toString();
        });
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch transaction ID: ${responseBody['message']}')),
        );
      }
    } else {
      // Handle server error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  void dispose() {
    _employeeIdController.removeListener(_onFormChange);
    _amountController.removeListener(_onFormChange);
    _titleController.removeListener(_onFormChange);
    _descriptionController.removeListener(_onFormChange);
    _dateController.removeListener(_onFormChange);
    _purposeController.removeListener(_onFormChange);

    _transactionIdController.dispose();
    _employeeIdController.dispose();
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _onFormChange() {
    setState(() {
      _isFormModified = true;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        _isFormModified = true;
      });
    }
  }

  void _showDiscardChangesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text('You have unsaved changes. Do you really want to discard them?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionsPage()),
                );
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  bool get _showSacramentalTypeDropdown {
    return _selectedTransactionType == 'Sacramental Collection' ||
           _selectedTransactionType == 'Sacramental Offering';
  }

  bool get _showSpecialEventTypeDropdown {
    return _selectedTransactionType == 'Special Event Collection' ||
           _selectedTransactionType == 'Special Event Offering';
  }

  bool get _showPurposeField {
    return _selectedTransactionType == 'Fund Raising' ||
           _selectedTransactionType == 'Donation' ||
           _selectedTransactionType == 'Expense';
  }

  Future<void> _recordTransaction() async {
    final transaction = Transaction(
      par_id: int.parse(_employeeIdController.text),
      type: _selectedTransactionType!,
      date: DateTime.parse(_dateController.text),
      amount: _amountController.text,
      title: _titleController.text,
      description: _descriptionController.text,
      sacramental_type: _selectedSacramentalType,
      special_event_type: _selectedSpecialEventType,
      purpose: _purposeController.text,
    );

    final url = 'http://${localhostInstance.ipServer}/dashboard/myfolder/saveTransaction.php'; // Replace with your server URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction.toJson()),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['success']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TransactionsPage()),
          );
        } else {
          // Handle failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to record transaction: ${responseBody['message']}')),
          );
        }
      } else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTopNavBar(),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: _buildForm(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildFormButtons(context),
      ),
    );
  }

  Widget _buildTopNavBar() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20.0, bottom: 8.0),
        child: Text(
          'RECORD \n FINANCIAL TRANSACTION',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        TextFormField(
          controller: _transactionIdController,
          decoration: const InputDecoration(
            labelText: 'Transaction ID',
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB37840)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB37840)),
            ),
          ),
          enabled: false,
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          controller: _employeeIdController,
          decoration: const InputDecoration(
            labelText: 'Employee ID',
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB37840)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB37840)),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Select Transaction Type',
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB37840)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB37840)),
            ),
          ),
          items: <String>[
            'Mass Collection',
            'Mass Offering',
            'Sacramental Collection',
            'Sacramental Offering',
            'Special Event Collection',
            'Special Event Offering',
            'Fund Raising',
            'Donation',
            'Expense'
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedTransactionType = value;
              _selectedSacramentalType = null;
              _selectedSpecialEventType = null;
              _isFormModified = true;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a Transaction Type';
            }
            return null;
          },
        ),
        if (_showSacramentalTypeDropdown) const SizedBox(height: 10.0),
        if (_showSacramentalTypeDropdown)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select Sacramental Type',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffB37840)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffB37840)),
              ),
            ),
            items: <String>[
              'Baptism',
              'Blessing',
              'Confirmation',
              'First Holy Communion',
              'Mass for the Dead',
              'Wedding'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSacramentalType = value;
                _isFormModified = true;
              });
            },
            validator: (value) {
              if (_showSacramentalTypeDropdown && (value == null || value.isEmpty)) {
                return 'Please select a Sacramental Type';
              }
              return null;
            },
          ),
        if (_showSpecialEventTypeDropdown) const SizedBox(height: 10.0),
        if (_showSpecialEventTypeDropdown)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select Special Event Type',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffB37840)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffB37840)),
              ),
            ),
            items: <String>[
              'Baptism',
              'Blessing',
              'Confirmation',
              'First Holy Communion',
              'Mass for the Dead',
              'Wedding'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSpecialEventType = value;
                _isFormModified = true;
              });
            },
            validator: (value) {
              if (_showSpecialEventTypeDropdown && (value == null || value.isEmpty)) {
                return 'Please select a Special Event Type';
              }
              return null;
            },
          ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Select Date',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffB37840)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffB37840)),
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a Date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Amount',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffB37840)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffB37840)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Amount';
                  }
                  final n = num.tryParse(value);
                  if (n == null) {
                    return 'Invalid amount';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Enter Title',
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB37840)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB37840)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a Title';
            }
            return null;
          },
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Enter Description',
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB37840)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB37840)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a Description';
            }
            return null;
          },
        ),
        if (_showPurposeField) const SizedBox(height: 10.0),
        if (_showPurposeField)
          TextFormField(
            controller: _purposeController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Purpose',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffB37840)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffB37840)),
              ),
            ),
            validator: (value) {
              if (_showPurposeField && (value == null || value.isEmpty)) {
                return 'Please enter Purpose of Transaction';
              }
              return null;
            },
          ),
      ],
    );
  }

  Widget _buildFormButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            if (_isFormModified) {
              _showDiscardChangesDialog(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TransactionsPage()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _recordTransaction();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          child: const Text(
            'Record',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}