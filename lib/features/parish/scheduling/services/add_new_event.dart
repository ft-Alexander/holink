import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddEventScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime, String, String, String, String, String, String,
      String, String, String) onSave;

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

  localhost localhostInstance = localhost();
  TimeOfDay? _selectedTime;

  String event_type = 'Public'; // Default value
  String selectedSacrament = 'Wedding'; // Default value
  String archive_status = 'display'; // Default value

  @override
  void initState() {
    super.initState();
    _dateController.text =
        DateFormat('MMMM d, yyyy').format(widget.selectedDate);
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
          Uri.parse(
              'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/events.php'),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {
            'event_datetime': eventDateTime.toIso8601String(),
            'event_name': _eventController.text,
            'priest': _priestController.text,
            'lectors': _lectorsController.text,
            'sacristan': _sacristanController.text,
            'address': _addressController.text,
            'details': _detailsController.text,
            'sacraments': selectedSacrament,
            'event_type': event_type,
            'archive_status': archive_status
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
                selectedSacrament,
                event_type,
                archive_status);
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

  void _updateSacramentDropdown(String newEventType) {
    setState(() {
      event_type = newEventType;
      if (event_type == 'Public') {
        selectedSacrament = 'Wedding';
      } else {
        selectedSacrament = 'Chapel Mass';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Event Details'),
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
                      labelText: 'Select Date',
                      suffixIcon: Icon(Icons.calendar_today,
                          color: const Color.fromARGB(255, 186, 163, 136)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 186, 163, 136)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 186, 163, 136)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 186, 163, 136)),
                      ),
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
                      labelText: 'Select Time',
                      suffixIcon: Icon(Icons.access_time,
                          color: const Color.fromARGB(255, 186, 163, 136)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 186, 163, 136)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 186, 163, 136)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 186, 163, 136)),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectTime(context),
                    controller: TextEditingController(
                      text: _selectedTime == null
                          ? ''
                          : _selectedTime!.format(context),
                    ),
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
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 186, 163, 136)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 186, 163, 136)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 186, 163, 136)),
                ),
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
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 186, 163, 136)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 186, 163, 136)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 186, 163, 136)),
                ),
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
        labelText: hintText,
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color.fromARGB(255, 186, 163, 136)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color.fromARGB(255, 186, 163, 136)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color.fromARGB(255, 186, 163, 136)),
        ),
      ),
    );
  }
}
