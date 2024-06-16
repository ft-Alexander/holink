import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _bill1000Controller = TextEditingController(text: '0');
  final TextEditingController _bill500Controller = TextEditingController(text: '0');
  final TextEditingController _bill200Controller = TextEditingController(text: '0');
  final TextEditingController _bill100Controller = TextEditingController(text: '0');
  final TextEditingController _bill50Controller = TextEditingController(text: '0');
  final TextEditingController _bill20Controller = TextEditingController(text: '0');
  final TextEditingController _coin20Controller = TextEditingController(text: '0');
  final TextEditingController _coin10Controller = TextEditingController(text: '0');
  final TextEditingController _coin5Controller = TextEditingController(text: '0');
  final TextEditingController _coin1Controller = TextEditingController(text: '0');
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _donatedByController = TextEditingController();

  String? _transactionCategory;
  String? _selectedTransactionType;
  String? _selectedSacramentalType;
  String? _selectedSpecialEventType;
  bool _isFormModified = false;
  bool _isUpdating = false;

  localhost localhostInstance = localhost();

  String archive_status = 'display';
  String parishioner_access = 'hidden';

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _employeeIdController.addListener(_onFormChange);
    _amountController.addListener(_onFormChange);
    _titleController.addListener(_onFormChange);
    _descriptionController.addListener(_onFormChange);
    _dateController.addListener(_onFormChange);
    _addDenominationListeners();
  }
  void _initializeFields() {
    _transactionIdController.text = widget.transaction.transaction_id.toString();
    _employeeIdController.text = widget.transaction.par_id.toString();
    _amountController.text = widget.transaction.amount;
    _dateController.text = DateFormat('yyyy-MM-dd').format(widget.transaction.date);
    _transactionCategory = widget.transaction.transaction_category;
    _selectedTransactionType = widget.transaction.type;
    _selectedSacramentalType = widget.transaction.sacramental_type;
    _selectedSpecialEventType = widget.transaction.special_event_type;

    // Initialize denomination controllers
    _bill1000Controller.text = widget.transaction.bill1000.toString();
    _bill500Controller.text = widget.transaction.bill500.toString();
    _bill200Controller.text = widget.transaction.bill200.toString();
    _bill100Controller.text = widget.transaction.bill100.toString();
    _bill50Controller.text = widget.transaction.bill50.toString();
    _bill20Controller.text = widget.transaction.bill20.toString();
    _coin20Controller.text = widget.transaction.coin20.toString();
    _coin10Controller.text = widget.transaction.coin10.toString();
    _coin5Controller.text = widget.transaction.coin5.toString();
    _coin1Controller.text = widget.transaction.coin1.toString();

    _purposeController.text = widget.transaction.purpose ?? '';
    _donatedByController.text = widget.transaction.donated_by ?? '';
  }

  void _addDenominationListeners() {
    _addListener(_bill1000Controller);
    _addListener(_bill500Controller);
    _addListener(_bill200Controller);
    _addListener(_bill100Controller);
    _addListener(_bill50Controller);
    _addListener(_bill20Controller);
    _addListener(_coin20Controller);
    _addListener(_coin10Controller);
    _addListener(_coin5Controller);
    _addListener(_coin1Controller);
  }

  void _addListener(TextEditingController controller) {
    controller.addListener(() {
      if (_isUpdating) return;
      _isUpdating = true;
      if (controller.text.isEmpty) {
        controller.text = '0';
        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
      } else if (controller.text == '0') {
        controller.text = '';
      }
      _isUpdating = false;
    });
  }

  @override
  void dispose() {
    _employeeIdController.removeListener(_onFormChange);
    _amountController.removeListener(_onFormChange);
    _titleController.removeListener(_onFormChange);
    _descriptionController.removeListener(_onFormChange);
    _dateController.removeListener(_onFormChange);
    _removeDenominationListeners();

    _transactionIdController.dispose();
    _employeeIdController.dispose();
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _purposeController.dispose();
    _donatedByController.dispose();
    super.dispose();
  }

  void _removeDenominationListeners() {
    _bill1000Controller.removeListener(_onFormChange);
    _bill500Controller.removeListener(_onFormChange);
    _bill200Controller.removeListener(_onFormChange);
    _bill100Controller.removeListener(_onFormChange);
    _bill50Controller.removeListener(_onFormChange);
    _bill20Controller.removeListener(_onFormChange);
    _coin20Controller.removeListener(_onFormChange);
    _coin10Controller.removeListener(_onFormChange);
    _coin5Controller.removeListener(_onFormChange);
    _coin1Controller.removeListener(_onFormChange);
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
    final amount = _calculateTotalAmount();
    _amountController.text = amount.toString();

    final transaction = Transaction(
      transaction_id: int.parse(_transactionIdController.text),
      par_id: int.parse(_employeeIdController.text),
      transaction_category: _transactionCategory!,
      type: _selectedTransactionType!,
      date: DateTime.parse(_dateController.text),
      amount: _amountController.text,
      sacramental_type: _selectedSacramentalType,
      special_event_type: _selectedSpecialEventType,
      archive_status: archive_status,
      parishioner_access: parishioner_access, // New field
      purpose: _purposeController.text,
      donated_by: _donatedByController.text,
      bill1000: int.tryParse(_bill1000Controller.text) ?? 0,
      bill500: int.tryParse(_bill500Controller.text) ?? 0,
      bill200: int.tryParse(_bill200Controller.text) ?? 0,
      bill100: int.tryParse(_bill100Controller.text) ?? 0,
      bill50: int.tryParse(_bill50Controller.text) ?? 0,
      bill20: int.tryParse(_bill20Controller.text) ?? 0,
      coin20: int.tryParse(_coin20Controller.text) ?? 0,
      coin10: int.tryParse(_coin10Controller.text) ?? 0,
      coin5: int.tryParse(_coin5Controller.text) ?? 0,
      coin1: int.tryParse(_coin1Controller.text) ?? 0,
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
    return _selectedTransactionType == 'Sacramental Collection' ||
           _selectedTransactionType == 'Sacramental Offering';
  }

  bool get _showSpecialEventTypeDropdown {
    return _selectedTransactionType == 'Special Event Collection' ||
           _selectedTransactionType == 'Special Event Offering';
  }

  bool get _showPurposeField {
    return _selectedTransactionType == 'Fund Raising';
  }

  bool get _showDonatedByField {
    return _selectedTransactionType == 'Donation';
  }

  double _calculateTotalAmount() {
    final bill1000 = int.tryParse(_bill1000Controller.text) ?? 0;
    final bill500 = int.tryParse(_bill500Controller.text) ?? 0;
    final bill200 = int.tryParse(_bill200Controller.text) ?? 0;
    final bill100 = int.tryParse(_bill100Controller.text) ?? 0;
    final bill50 = int.tryParse(_bill50Controller.text) ?? 0;
    final bill20 = int.tryParse(_bill20Controller.text) ?? 0;
    final coin20 = int.tryParse(_coin20Controller.text) ?? 0;
    final coin10 = int.tryParse(_coin10Controller.text) ?? 0;
    final coin5 = int.tryParse(_coin5Controller.text) ?? 0;
    final coin1 = int.tryParse(_coin1Controller.text) ?? 0;

    return bill1000 * 1000 +
        bill500 * 500 +
        bill200 * 200 +
        bill100 * 100 +
        bill50 * 50 +
        bill20 * 20 +
        coin20 * 20 +
        coin10 * 10 +
        coin5 * 5 +
        coin1 * 1;
  }

  bool _atLeastOneDenominationFilled() {
    return int.tryParse(_bill1000Controller.text) != 0 ||
           int.tryParse(_bill500Controller.text) != 0 ||
           int.tryParse(_bill200Controller.text) != 0 ||
           int.tryParse(_bill100Controller.text) != 0 ||
           int.tryParse(_bill50Controller.text) != 0 ||
           int.tryParse(_bill20Controller.text) != 0 ||
           int.tryParse(_coin20Controller.text) != 0 ||
           int.tryParse(_coin10Controller.text) != 0 ||
           int.tryParse(_coin5Controller.text) != 0 ||
           int.tryParse(_coin1Controller.text) != 0;
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
          enabled: false,
        ),
        const SizedBox(height: 10.0),
        _buildTransactionCategoryRadio(),
        const SizedBox(height: 10.0),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Select Transaction Type',
            border: OutlineInputBorder(),
          ),
          value: _selectedTransactionType,
          items: _getTransactionTypes().map((String value) {
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

              if (!_showPurposeField) {
                _purposeController.clear();
              }
              if (!_showDonatedByField) {
                _donatedByController.clear();
              }
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
          ],
        ),
        const SizedBox(height: 10.0),
        _buildDenominationsForm(),
        if (_showPurposeField) const SizedBox(height: 10.0),
        if (_showPurposeField)
          TextFormField(
            controller: _purposeController,
            decoration: const InputDecoration(
              labelText: 'Purpose',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (_showPurposeField && (value == null || value.isEmpty)) {
                return 'Please enter the purpose';
              }
              return null;
            },
          ),
        if (_showDonatedByField) const SizedBox(height: 10.0),
        if (_showDonatedByField)
          TextFormField(
            controller: _donatedByController,
            decoration: const InputDecoration(
              labelText: 'Donated By',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (_showDonatedByField && (value == null || value.isEmpty)) {
                return 'Please enter the donor\'s name';
              }
              return null;
            },
          ),
      ],
    );
  }

  Widget _buildDenominationsForm() {
    return Column(
      children: [
        _buildDenominationField('1000 Bill', _bill1000Controller),
        _buildDenominationField('500 Bill', _bill500Controller),
        _buildDenominationField('200 Bill', _bill200Controller),
        _buildDenominationField('100 Bill', _bill100Controller),
        _buildDenominationField('50 Bill', _bill50Controller),
        _buildDenominationField('20 Bill', _bill20Controller),
        _buildDenominationField('20 Coin', _coin20Controller),
        _buildDenominationField('10 Coin', _coin10Controller),
        _buildDenominationField('5 Coin', _coin5Controller),
        _buildDenominationField('1 Coin', _coin1Controller),
      ],
    );
  }

  Widget _buildDenominationField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onTap: () {
          if (controller.text == '0') {
            controller.clear();
          }
        },
        onEditingComplete: () {
          if (controller.text.isEmpty) {
            controller.text = '0';
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the number of $label';
          }
          final n = num.tryParse(value);
          if (n == null) {
            return 'Invalid number';
          }
          return null;
        },
      ),
    );
  }

  List<String> _getTransactionTypes() {
    if (_transactionCategory == 'Collection') {
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
    } else if (_transactionCategory == 'Expense') {
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

  Widget _buildTransactionCategoryRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Radio<String>(
              value: 'Collection',
              groupValue: _transactionCategory,
              onChanged: (value) {
                setState(() {
                  _transactionCategory = value;
                  _selectedTransactionType = null;
                });
              },
            ),
            const Text('Collection'),
          ],
        ),
        const SizedBox(width: 20.0),
        Row(
          children: [
            Radio<String>(
              value: 'Expense',
              groupValue: _transactionCategory,
              onChanged: (value) {
                setState(() {
                  _transactionCategory = value;
                  _selectedTransactionType = null;
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
