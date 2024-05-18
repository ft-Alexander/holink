import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddEventScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime, String, String, String, String, String, String)
      onSave;

  const AddEventScreen(
      {required this.selectedDate, required this.onSave, Key? key})
      : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _priestController = TextEditingController();
  final TextEditingController _sacristanController = TextEditingController();
  final TextEditingController _lectorsController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
  }

  @override
  void dispose() {
    _eventController.dispose();
    _priestController.dispose();
    _sacristanController.dispose();
    _lectorsController.dispose();
    _addressController.dispose();
    _detailsController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveEvent() async {
    if (_eventController.text.isNotEmpty &&
        _priestController.text.isNotEmpty &&
        _lectorsController.text.isNotEmpty &&
        _sacristanController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _detailsController.text.isNotEmpty &&
        _selectedTime != null) {
      final DateTime eventDateTime = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.46/dashboard/myfolder/events.php'),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {
            'event_datetime': eventDateTime.toIso8601String(),
            'event_name': _eventController.text,
            'priest': _priestController.text,
            'lectors': _lectorsController.text,
            'sacristan': _sacristanController.text,
            'address': _addressController.text,
            'details': _detailsController.text,
          },
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['message'] == 'New record created successfully') {
            widget.onSave(
              eventDateTime,
              _eventController.text,
              _priestController.text,
              _lectorsController.text,
              _sacristanController.text,
              _addressController.text,
              _detailsController.text,
            );
            Navigator.pop(context);
          } else {
            _showErrorDialog(context, responseData['message']);
          }
        } else {
          _showErrorDialog(
              context, 'Failed to save event: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog(context, 'An error occurred: $e');
      }
    } else {
      _showErrorDialog(context, 'Please fill in all fields and select a time.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        automaticallyImplyLeading: false,
        title: Text('Add Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: 'Select Date',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () {
                      // Date picker code here if needed
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Select Time',
                      suffixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () => _selectTime(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildTextField(_eventController, 'Event Name'),
            SizedBox(height: 16),
            _buildTextField(_priestController, 'Select Priest'),
            SizedBox(height: 16),
            _buildTextField(_lectorsController, 'Select Lectors'),
            SizedBox(height: 16),
            _buildTextField(_sacristanController, 'Assign Sacristan'),
            SizedBox(height: 16),
            _buildTextField(_addressController, 'Enter Address'),
            SizedBox(height: 16),
            _buildTextField(_detailsController, 'Additional Details',
                maxLines: 4),
            SizedBox(height: 16),
            Row(
              children: [
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Cancel"),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }
}