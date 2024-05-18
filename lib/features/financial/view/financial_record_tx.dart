import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:holink/features/financial/view/financial_transactions.dart';

import 'package:holink/features/financial/controller/transaction_state.dart';
import 'package:holink/features/financial/controller/transaction.dart';

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

  @override
  void initState() {
    super.initState();
    _transactionIdController.addListener(_onFormChange);
    _employeeIdController.addListener(_onFormChange);
    _amountController.addListener(_onFormChange);
    _titleController.addListener(_onFormChange);
    _descriptionController.addListener(_onFormChange);
    _dateController.addListener(_onFormChange);
    _purposeController.addListener(_onFormChange);
  }

  @override
  void dispose() {
    _transactionIdController.removeListener(_onFormChange);
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
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a Transaction ID';
            }
            return null;
          },
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an Employee ID';
            }
            return null;
          },
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
              'Confirmation',
              'Eucharist',
              'Marriage',
              'Anointing of the Sick'
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
              'Anniversary',
              'Funeral',
              'Wedding',
              'Charity Event'
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
              Transaction newTransaction = Transaction(
                title: _titleController.text,
                transactionId: _transactionIdController.text,
                employeeId: _employeeIdController.text,
                type: _selectedTransactionType!,
                date: _dateController.text,
                amount: _amountController.text,
                description: _descriptionController.text,
                sacramentalType: _selectedSacramentalType,
                specialEventType: _selectedSpecialEventType,
                purpose: _purposeController.text,
              );
              Provider.of<TransactionState>(context, listen: false).addTransaction(newTransaction);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TransactionsPage()),
              );
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
