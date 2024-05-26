import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:holink/features/scheduling/model/getEvent.dart'; // Replace with the correct path to your Event model

class EditScheduleScreen extends StatefulWidget {
  final getEvent event;

  const EditScheduleScreen({super.key, required this.event});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  late TextEditingController _eventController;
  late TextEditingController _priestController;
  late TextEditingController _sacristanController;
  late TextEditingController _lectorsController;
  late TextEditingController _addressController;
  late TextEditingController _detailsController;
  late TextEditingController _dateController;

  localhost localhostInstance = localhost();
  TimeOfDay? _selectedTime;
  late String event_type;
  late String selectedSacrament;

  @override
  void initState() {
    super.initState();
    _eventController = TextEditingController(text: widget.event.title);
    _priestController = TextEditingController(text: widget.event.priest);
    _sacristanController = TextEditingController(text: widget.event.sacristan);
    _lectorsController = TextEditingController(text: widget.event.lectors);
    _addressController = TextEditingController(text: widget.event.address);
    _detailsController = TextEditingController(text: widget.event.details);
    _dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.event.date));
    _selectedTime = TimeOfDay.fromDateTime(widget.event.date);
    event_type = widget.event.event_type;
    selectedSacrament = widget.event.sacraments;

    _validateSelectedSacrament(); // Ensure selectedSacrament is valid initially
  }

  void _validateSelectedSacrament() {
    final validSacraments = (event_type == 'Public'
        ? ['Wedding', 'Baptism', 'Blessing']
        : ['Chapel Mass', 'Parish Mass', 'Barangay Mass']);
    if (!validSacraments.contains(selectedSacrament)) {
      selectedSacrament = validSacraments.first;
    }
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
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _updateEvent() async {
    if (_eventController.text.isNotEmpty &&
        _priestController.text.isNotEmpty &&
        _lectorsController.text.isNotEmpty &&
        _sacristanController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _detailsController.text.isNotEmpty &&
        _selectedTime != null) {
      final DateTime eventDateTime = DateTime(
        widget.event.date.year,
        widget.event.date.month,
        widget.event.date.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      print('Event DateTime: $eventDateTime');
      print('Event Data: ${{
        's_id': widget.event.s_id.toString(),
        'event_datetime': eventDateTime.toIso8601String(),
        'event_name': _eventController.text,
        'priest': _priestController.text,
        'lectors': _lectorsController.text,
        'sacristan': _sacristanController.text,
        'address': _addressController.text,
        'details': _detailsController.text,
        'sacraments': selectedSacrament,
        'event_type': event_type,
      }}');

      try {
        final response = await http.post(
          Uri.parse(
              'http://${localhostInstance.ipServer}/dashboard/myfolder/updateEvent.php'), // Ensure the correct endpoint
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {
            's_id': widget.event.s_id.toString(),
            'event_datetime': eventDateTime.toIso8601String(),
            'event_name': _eventController.text,
            'priest': _priestController.text,
            'lectors': _lectorsController.text,
            'sacristan': _sacristanController.text,
            'address': _addressController.text,
            'details': _detailsController.text,
            'sacraments': selectedSacrament,
            'event_type': event_type,
          },
        );

        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['message'] == 'Event updated successfully') {
            Navigator.pop(context, true); // Pass true to indicate success
          } else {
            print('Error Response Data: $responseData');
            _showErrorDialog(context, responseData['message']);
          }
        } else {
          _showErrorDialog(
              context, 'Failed to update event: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
        _showErrorDialog(context, 'An error occurred: $e');
      }
    } else {
      print('Validation Error: Please fill in all fields and select a time.');
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

  void _updateSacramentDropdown(String newEventType) {
    setState(() {
      event_type = newEventType;
      _validateSelectedSacrament(); // Ensure selectedSacrament is valid after updating event_type
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Edit Event'),
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
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
              ),
              hint: Text("Select Event Type"),
              value: event_type,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _updateSacramentDropdown(newValue);
                }
              },
              items: const ['Regular', 'Public'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Color.fromARGB(255, 63, 63, 63),
                      fontFamily: 'DM Sans',
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
              ),
              hint: Text("Select Sacrament"),
              value: selectedSacrament,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSacrament = newValue!;
                });
              },
              items: (event_type == 'Public'
                      ? ['Wedding', 'Baptism', 'Blessing', 'Seminar']
                      : [
                          'Chapel Mass',
                          'Parish Mass',
                          'Barangay Mass',
                          'Confession'
                        ])
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Color.fromARGB(255, 63, 63, 63),
                      fontFamily: 'DM Sans',
                    ),
                  ),
                );
              }).toList(),
            ),
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
                  onPressed: _updateEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Update"),
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
