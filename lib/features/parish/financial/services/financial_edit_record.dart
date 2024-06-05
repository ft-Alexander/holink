import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/parish/financial/view/financial_transactions.dart';
import 'package:holink/features/parish/financial/model/transaction.dart';

class EditFinancialTransactionPage extends StatefulWidget {
  final Transaction transaction;

  const EditFinancialTransactionPage({super.key, required this.transaction});

  @override
  _EditFinancialTransactionPageState createState() => _EditFinancialTransactionPageState();
}

class _EditFinancialTransactionPageState extends State<EditFinancialTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _transactionIdController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _transactionType;
  String? _selectedTransactionCategory;
  String? _selectedSacramentalType;
  String? _selectedSpecialEventType;
  bool _isFormModified = false;

  localhost localhostInstance = localhost();

  String archive_status = 'display';

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _employeeIdController.addListener(_onFormChange);
    _amountController.addListener(_onFormChange);
    _titleController.addListener(_onFormChange);
    _descriptionController.addListener(_onFormChange);
    _dateController.addListener(_onFormChange);
  }

  void _initializeFields() {
    _transactionIdController.text = widget.transaction.transaction_id.toString();
    _employeeIdController.text = widget.transaction.par_id.toString();
    _amountController.text = widget.transaction.amount;
    _titleController.text = widget.transaction.title;
    _descriptionController.text = widget.transaction.description;
    _dateController.text = DateFormat('yyyy-MM-dd').format(widget.transaction.date);
    _transactionType = widget.transaction.type;
    _selectedTransactionCategory = widget.transaction.transaction_category;
    _selectedSacramentalType = widget.transaction.sacramental_type;
    _selectedSpecialEventType = widget.transaction.special_event_type;
  }

  @override
  void dispose() {
    _employeeIdController.removeListener(_onFormChange);
    _amountController.removeListener(_onFormChange);
    _titleController.removeListener(_onFormChange);
    _descriptionController.removeListener(_onFormChange);
    _dateController.removeListener(_onFormChange);

    _transactionIdController.dispose();
    _employeeIdController.dispose();
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
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

  Future<void> _editTransaction() async {
    final transaction = Transaction(
      transaction_id: int.parse(_transactionIdController.text),
      par_id: int.parse(_employeeIdController.text),
      type: _transactionType!,
      transaction_category: _selectedTransactionCategory!,
      date: DateTime.parse(_dateController.text),
      amount: _amountController.text,
      title: _titleController.text,
      description: _descriptionController.text,
      sacramental_type: _selectedSacramentalType,
      special_event_type: _selectedSpecialEventType,
      archive_status: archive_status,
    );

    final url = 'http://${localhostInstance.ipServer}/dashboard/myfolder/finance/editTransactions.php'; // Replace with your server URL

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to edit transaction: ${responseBody['message']}')),
          );
        }
      } else {
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

  bool get _showSacramentalTypeDropdown {
    return _selectedTransactionCategory == 'Sacramental Collection' ||
           _selectedTransactionCategory == 'Sacramental Offering';
  }

  bool get _showSpecialEventTypeDropdown {
    return _selectedTransactionCategory == 'Special Event Collection' ||
           _selectedTransactionCategory == 'Special Event Offering';
  }

  List<String> _getTransactionCategories() {
    if (_transactionType == 'Income') {
      return [
        'Mass Collection',
        'Mass Offering',
        'Sacramental Collection',
        'Sacramental Offering',
        'Special Event Collection',
        'Special Event Offering',
        'Fund Raising',
        'Donation'
      ];
    } else if (_transactionType == 'Expense') {
      return [
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
      ];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Edit Financial Transaction'),
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

  Widget _buildForm() {
    return Column(
      children: [
        TextFormField(
          controller: _transactionIdController,
          decoration: const InputDecoration(
            labelText: 'Transaction ID',
            border: OutlineInputBorder(),
          ),
          enabled: false,
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          controller: _employeeIdController,
          decoration: const InputDecoration(
            labelText: 'Employee ID',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10.0),
        _buildTransactionTypeRadio(),
        const SizedBox(height: 10.0),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Select Transaction Category',
            border: OutlineInputBorder(),
          ),
          value: _selectedTransactionCategory,
          items: _getTransactionCategories().map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedTransactionCategory = value;
              _selectedSacramentalType = null;
              _selectedSpecialEventType = null;
              _isFormModified = true;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a Transaction Category';
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
            value: _selectedSacramentalType,
          ),
        if (_showSpecialEventTypeDropdown) const SizedBox(height: 10.0),
        if (_showSpecialEventTypeDropdown)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select Special Event Type',
              border: OutlineInputBorder(),
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
            value: _selectedSpecialEventType,
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
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a Description';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTransactionTypeRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Radio<String>(
              value: 'Income',
              groupValue: _transactionType,
              onChanged: (value) {
                setState(() {
                  _transactionType = value;
                  _selectedTransactionCategory = null;
                });
              },
            ),
            const Text('Income'),
          ],
        ),
        const SizedBox(width: 20.0),
        Row(
          children: [
            Radio<String>(
              value: 'Expense',
              groupValue: _transactionType,
              onChanged: (value) {
                setState(() {
                  _transactionType = value;
                  _selectedTransactionCategory = null;
                });
              },
            ),
            const Text('Expense'),
          ],
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
              Navigator.pop(context);
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const TransactionsPage()),
                (Route<dynamic> route) => false,
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
              _editTransaction();
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
            'Save',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
