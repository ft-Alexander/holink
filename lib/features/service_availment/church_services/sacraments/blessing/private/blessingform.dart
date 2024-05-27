import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'reviewInformation.dart'; // Import the ReviewInformation file
import '../../../../model/service_model.dart'; // Import the ServiceInformation model

class BlessingForm extends StatefulWidget {
  const BlessingForm({super.key});

  @override
  _BlessingFormState createState() => _BlessingFormState();
}

class _BlessingFormState extends State<BlessingForm> {
  final _formKey = GlobalKey<FormState>();
  localhost localhostInstance = localhost();

  // Form fields
  bool houseSelected = false;
  bool storeSelected = false;
  bool othersSelected = false;
  TextEditingController othersController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController skkController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    othersController.dispose();
    nameController.dispose();
    skkController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    contactController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  bool _allFieldsFilled() {
    return nameController.text.isNotEmpty &&
        skkController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        contactController.text.isNotEmpty &&
        selectedDate != null &&
        selectedTime != null &&
        (houseSelected ||
            storeSelected ||
            (othersSelected && othersController.text.isNotEmpty));
  }

  String _getSelectedType() {
    if (houseSelected) return 'House';
    if (storeSelected) return 'Store';
    if (othersSelected) return othersController.text;
    return '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        timeController.text = picked.format(context);
      });
    }
  }

  void _saveEvent() async {
    if (_allFieldsFilled()) {
      final DateTime eventDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      ServiceInformation serviceInformation = ServiceInformation(
        date_availed: DateTime.now(),
        scheduled_date: eventDateTime,
        service: 'BLESSING',
        serviceType: 'Private',
        fullName: nameController.text,
        skkNumber: skkController.text,
        address: addressController.text,
        landmark: landmarkController.text,
        contactNumber: contactController.text,
        selectedType: _getSelectedType(),
      );

      final url = Uri.parse(
          'http://${localhostInstance.ipServer}/dashboard/myfolder/service/savePrivateEvent.php');
      print('Saving to database: $url'); // Debug print statement
      try {
        final response = await http.post(
          url,
          // headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {
            'date_availed': serviceInformation.date_availed.toIso8601String(),
            'scheduled_date':
                serviceInformation.scheduled_date.toIso8601String(),
            'service': serviceInformation.service,
            'serviceType': serviceInformation.serviceType,
            'fullName': serviceInformation.fullName,
            'skkNumber': serviceInformation.skkNumber,
            'address': serviceInformation.address,
            'landmark': serviceInformation.landmark,
            'contactNumber': serviceInformation.contactNumber,
            'selectedType': serviceInformation.selectedType,
          },
        );

        print(
            'Response status: ${response.statusCode}'); // Debug print statement
        print('Response body: ${response.body}'); // Debug print statement

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          if (responseBody['success']) {
            // Navigate to the next screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewInformation(
                  serviceInformation: serviceInformation,
                ),
              ),
            );
          } else {
            print('Failed to save data: ${responseBody['message']}');
            _showErrorMessage(
                'Failed to save data: ${responseBody['message']}');
          }
        } else {
          print('Failed to save data: ${response.statusCode}');
          _showErrorMessage('Failed to save data: ${response.statusCode}');
        }
      } catch (error) {
        print('An error occurred: $error');
        _showErrorMessage('An error occurred: $error');
      }
    } else {
      _showErrorMessage('Please fill in all fields and select a time.');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Type:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Checkbox(
              value: houseSelected,
              onChanged: (bool? value) {
                setState(() {
                  houseSelected = value!;
                  storeSelected = false;
                  othersSelected = false;
                  othersController.clear();
                });
              },
            ),
            const Text('House'),
            Checkbox(
              value: storeSelected,
              onChanged: (bool? value) {
                setState(() {
                  storeSelected = value!;
                  houseSelected = false;
                  othersSelected = false;
                  othersController.clear();
                });
              },
            ),
            const Text('Store'),
            Checkbox(
              value: othersSelected,
              onChanged: (bool? value) {
                setState(() {
                  othersSelected = value!;
                  houseSelected = false;
                  storeSelected = false;
                });
              },
            ),
            const Text('Others (Please Specify):'),
            if (othersSelected)
              Expanded(
                child: TextFormField(
                  controller: othersController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildScheduleDateAndTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schedule Date (Refer to Calendar for Date Availability)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: dateController,
          labelText: 'MM/DD/YYYY',
          readOnly: true,
          onTap: () => _selectDate(context),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the date';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: timeController,
          labelText: '00:00 AM/PM',
          readOnly: true,
          onTap: () => _selectTime(context),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the time';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'ADD INFORMATION',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 2.0,
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: () {
            setState(
                () {}); // Rebuild form on field changes to update button state
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFd1a65b), // Button background color
                      minimumSize: const Size.fromHeight(50), // Set height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'BLESSING',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please enter necessary information below.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildTypeSelection(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: nameController,
                  labelText: 'Full Name (First Name, Middle Name, Surname)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: skkController,
                  labelText: 'SKK NO:',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your SKK number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: addressController,
                  labelText: 'Address:',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: landmarkController,
                  labelText: 'Nearby Landmark:',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: contactController,
                  labelText: 'Contact Number:',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildScheduleDateAndTime(),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: _allFieldsFilled() ? _saveEvent : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _allFieldsFilled() ? Colors.green : Colors.grey,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Next', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
