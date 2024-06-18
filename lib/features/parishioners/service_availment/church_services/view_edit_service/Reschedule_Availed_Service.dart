import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:holink/dbConnection/localhost.dart';

class RescheduleAvailedService extends StatefulWidget {
  final int serviceIndex;
  final Map<String, String> serviceDetails; // Add serviceDetails parameter

  const RescheduleAvailedService({
    super.key,
    required this.serviceIndex,
    required this.serviceDetails, // Add this line
  });

  @override
  _RescheduleAvailedServiceState createState() => _RescheduleAvailedServiceState();
}

class _RescheduleAvailedServiceState extends State<RescheduleAvailedService> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  bool isLoading = true;
  int id = 0;
  localhost localhostInstance = localhost(); // Add this line

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    fetchServiceDetails();
  }

  Future<void> fetchServiceDetails() async {
    setState(() {
      _dateController.text = widget.serviceDetails["event_date"]?.split(' ').first ?? '';
      _timeController.text = widget.serviceDetails["event_date"]?.split(' ').last ?? '';
      id = int.parse(widget.serviceDetails["event_type_id"]!);
      isLoading = false;
    });
  }

  void showError(String message) {
    print('Error: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _submitReschedule() async {
    if (_formKey.currentState!.validate()) {
      try {
        final inputDate = _dateController.text;
        final inputTime = _timeController.text;

        // Combine date and time into a DateTime object
        final DateFormat dateFormat = DateFormat('MM/dd/yyyy hh:mm a');
        final DateTime eventDateTime = dateFormat.parse('$inputDate $inputTime');

        // Convert DateTime object to a string format suitable for the database
        final DateFormat outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        final String formattedDateTime = outputFormat.format(eventDateTime);

        final url = Uri.parse('http://${localhostInstance.ipServer}/dashboard/myfolder/service/rescheduleAvailedServiceBlessing.php'); // Use localhost instance
        final body = {
          'id': id.toString(),
          'event_datetime': formattedDateTime,
        };

        print('Sending request to $url with body: $body');
        final response = await http.post(url, body: body);
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        final data = json.decode(response.body);
        print('Parsed data: $data');
        if (data['success']) {
          Navigator.pop(context, 'updated');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Service rescheduled successfully.')),
          );
        } else {
          showError('Failed to reschedule service: ${data['message']}');
        }
      } catch (error) {
        print('Error rescheduling service: $error');
        showError('An error occurred while rescheduling service: $error');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'RESCHEDULE SERVICE',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 118, 164, 38),
                    ),
                  ),
                ),
              ),
              Container(
                height: 2.0,
                color: Colors.green,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Scheduled Date (MM/DD/YYYY)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the scheduled date';
                        }
                        return null;
                      },
                      onTap: () => _selectDate(context),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        labelText: 'Time (00:00 AM/PM)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the time';
                        }
                        return null;
                      },
                      onTap: () => _selectTime(context),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: _submitReschedule,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
