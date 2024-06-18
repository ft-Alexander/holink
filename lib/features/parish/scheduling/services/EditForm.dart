import 'package:flutter/material.dart';
import 'package:holink/features/parish/scheduling/model/get_all_event.dart';
import 'package:holink/features/parish/scheduling/services/event_service.dart';
import 'package:intl/intl.dart';

class EditForm extends StatefulWidget {
  final int eventDateId;

  EditForm({required this.eventDateId});

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController eventTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController regularEventAddressController =
      TextEditingController();
  final TextEditingController skkNumberController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController selectTypeController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();

  int? eventId;
  int? specialEventId;
  DateTime? availedDate;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isLoading = true;
  String errorMessage = '';
  final EventService eventService = EventService();

  String eventName = "";

  @override
  void initState() {
    super.initState();
    _fetchAllDataId();
  }

  Future<void> _fetchAllDataId() async {
    try {
      final List<FetchEvents> events =
          await eventService.getEventsByDateId(widget.eventDateId);
      setState(() {
        if (events.isNotEmpty) {
          FetchEvents event = events.first;
          eventId = event.eventId;
          specialEventId = event.specialEventId;
          availedDate = event.eventDate;
          eventName = event.eventName?.isNotEmpty == true
              ? event.eventName!
              : event.specialEventName ?? '';
          eventTypeController.text = event.eventType ?? '';
          descriptionController.text = event.description?.isNotEmpty == true
              ? event.description!
              : '${event.service} for ${event.specialEventName}' ?? '';
          regularEventAddressController.text =
              event.regularEventAddress?.isNotEmpty == true
                  ? event.regularEventAddress!
                  : event.specialEventAddress ?? '';
          skkNumberController.text = event.skkNumber ?? '';
          landmarkController.text = event.landmark ?? '';
          contactNumberController.text = event.contactNumber ?? '';
          selectTypeController.text = event.selectType ?? '';
          serviceController.text = event.service ?? '';
          selectedDate = event.eventDate;
          selectedTime =
              TimeOfDay.fromDateTime(event.eventDate ?? DateTime.now());
          isLoading = false;

          // Print the events to the console
          for (var event in events) {
            print(event.toJson());
          }
        } else {
          errorMessage = 'No event found for the given date ID.';
          isLoading = false;
        }
      });
    } catch (e) {
      print('Error fetching event details: $e');
      setState(() {
        errorMessage = 'An error occurred while fetching the event details: $e';
        isLoading = false;
      });
    }
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
      });
    }
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final DateTime dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  Color _getEventTypeColor(String eventType) {
    switch (eventType) {
      case 'Regular':
        return Colors.green;
      case 'Special':
        return Colors.brown;
      case 'Event':
        return Colors.orange;
      default:
        return Colors.grey[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isEmpty
                ? Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              eventName,
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            width: 160, // Adjust the width as needed
                            decoration: BoxDecoration(
                              color:
                                  _getEventTypeColor(eventTypeController.text),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Round the borders
                            ),
                            child: Text(
                              eventTypeController.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors
                                      .white), // Set the text color to white
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: selectedDate != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(selectedDate!)
                                    : '',
                              ),
                              decoration: InputDecoration(labelText: 'Date'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _selectTime(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: selectedTime != null
                                    ? selectedTime!.format(context)
                                    : '',
                              ),
                              decoration: InputDecoration(labelText: 'Time'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a time';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        if (regularEventAddressController.text.isNotEmpty)
                          TextFormField(
                            controller: regularEventAddressController,
                            decoration: InputDecoration(labelText: 'Location'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter location';
                              }
                              return null;
                            },
                          ),
                        SizedBox(height: 10),
                        if (descriptionController.text.isNotEmpty)
                          TextFormField(
                            controller: descriptionController,
                            decoration:
                                InputDecoration(labelText: 'Description'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter description';
                              }
                              return null;
                            },
                          ),
                        SizedBox(height: 10),
                        if (skkNumberController.text.isNotEmpty)
                          TextFormField(
                            controller: skkNumberController,
                            decoration:
                                InputDecoration(labelText: 'SKK Number'),
                          ),
                        SizedBox(height: 10),
                        if (landmarkController.text.isNotEmpty)
                          TextFormField(
                            controller: landmarkController,
                            decoration: InputDecoration(labelText: 'Landmark'),
                          ),
                        SizedBox(height: 10),
                        if (contactNumberController.text.isNotEmpty)
                          TextFormField(
                            controller: contactNumberController,
                            decoration:
                                InputDecoration(labelText: 'Contact Number'),
                          ),
                        SizedBox(height: 10),
                        if (selectTypeController.text.isNotEmpty)
                          TextFormField(
                            controller: selectTypeController,
                            decoration:
                                InputDecoration(labelText: 'Select Type'),
                          ),
                        SizedBox(height: 10),
                        if (serviceController.text.isNotEmpty)
                          TextFormField(
                            controller: serviceController,
                            decoration: InputDecoration(labelText: 'Service'),
                          ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _showConfirmationDialog();
                                }
                              },
                              child: Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Center(child: Text(errorMessage)),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Save'),
          content: Text('Are you sure you want to save these changes?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _saveFormData();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveFormData() async {
    final DateTime dateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final Map<String, dynamic> data = {
      'eventDateId': widget.eventDateId,
      'eventDate': DateFormat('yyyy-MM-dd HH:mm').format(dateTime),
      'archiveStatus': 'Display',
      'eventType': eventTypeController.text,
      'eventId': eventId,
      'eventName': eventName,
      'description': descriptionController.text,
      'regularEventAddress': regularEventAddressController.text,
      'specialEventId': specialEventId,
      'specialEventName': eventName,
      'skkNumber': skkNumberController.text,
      'specialEventAddress': regularEventAddressController.text,
      'landmark': landmarkController.text,
      'contactNumber': contactNumberController.text,
      'availedDate': availedDate != null
          ? DateFormat('yyyy-MM-dd').format(availedDate!)
          : null,
      'selectType': selectTypeController.text,
      'service': serviceController.text,
    };

    try {
      final response = await eventService.saveEventData(data);
      if (response['success']) {
        print('Event saved successfully.');
        Navigator.of(context).pop(); // Go back after saving
      } else {
        print('Failed to save event: ${response['message']}');
      }
    } catch (e) {
      print('Failed to save event: $e');
    }
  }
}
