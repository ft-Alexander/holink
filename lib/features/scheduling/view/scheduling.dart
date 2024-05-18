import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:holink/features/scheduling/controllers/events.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Scheduling extends StatefulWidget {
  const Scheduling({super.key});

  @override
  State<Scheduling> createState() => _SchedulingState();
}

class _SchedulingState extends State<Scheduling> {
  late Map<DateTime, List<Event>> selectedEvents;
  DateTime focusedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  TextEditingController _eventController = TextEditingController();
  TextEditingController _priestController = TextEditingController();
  TextEditingController _sacristanController = TextEditingController();
  TextEditingController _lectorsController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();

  TimeOfDay? _selectedTime;

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    _priestController.dispose();
    _sacristanController.dispose();
    _lectorsController.dispose();
    _addressController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildCalendar(),
              const SizedBox(height: 16.0),
              _buildLegend(),
              const SizedBox(height: 16.0),
              _buildAddEventButton(context),
              ..._buildEventList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color.fromRGBO(179, 120, 64, 1.0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          TableCalendar(
            focusedDay: focusedDate,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            daysOfWeekVisible: true,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                focusedDate = focusedDay;
              });
            },
            selectedDayPredicate: (date) {
              return isSameDay(selectedDate, date);
            },
            eventLoader: _getEventsFromDay,
            calendarStyle: const CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFCDA782), Color(0xFFEFDBC7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFE8DACE), Color(0xFFD0CDC9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: false,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Color.fromRGBO(179, 120, 64, 1.0),
                border: Border.all(color: Color.fromRGBO(179, 120, 64, 1.0)),
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Legend: ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Icon(Icons.circle, color: Colors.brown, size: 10),
            SizedBox(width: 4),
            Text('Public Event'),
          ],
        ),
        SizedBox(width: 16),
        Row(
          children: [
            Icon(Icons.circle, color: Colors.orange, size: 10),
            SizedBox(width: 4),
            Text('Private Event'),
          ],
        ),
        SizedBox(width: 16),
        Row(
          children: [
            Icon(Icons.circle, color: Colors.green, size: 10),
            SizedBox(width: 4),
            Text('Regular Event'),
          ],
        ),
      ],
    );
  }

  Widget _buildAddEventButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showAddEventDialog(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          backgroundColor: Color(0xFF57CA63),
          padding: EdgeInsets.symmetric(vertical: 8.0),
        ),
        child: Text(
          'Add Event',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    TimeOfDay? localSelectedTime = _selectedTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Event'),
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWideScreen = constraints.maxWidth > 600;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _eventController,
                          decoration: InputDecoration(
                            hintText: 'Enter event title',
                          ),
                        ),
                        SizedBox(height: 16),
                        isWideScreen
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _priestController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Priest name',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _lectorsController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Lectors names',
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  TextFormField(
                                    controller: _priestController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Priest name',
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: _lectorsController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Lectors names',
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _sacristanController,
                          decoration: InputDecoration(
                            hintText: 'Enter Sacristan name',
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintText: 'Enter Address',
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _detailsController,
                          decoration: InputDecoration(
                            hintText: 'Enter Details',
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    localSelectedTime = picked;
                                  });
                                }
                              },
                              child: Text("Select Time"),
                            ),
                            Spacer(),
                            Text(
                              localSelectedTime == null
                                  ? 'No time selected'
                                  : '${localSelectedTime?.format(context)}',
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (_eventController.text.isNotEmpty &&
                      _priestController.text.isNotEmpty &&
                      _lectorsController.text.isNotEmpty &&
                      _sacristanController.text.isNotEmpty &&
                      _addressController.text.isNotEmpty &&
                      _detailsController.text.isNotEmpty &&
                      localSelectedTime != null) {
                    final DateTime eventDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      localSelectedTime!.hour,
                      localSelectedTime!.minute,
                    );

                    final event = Event(
                      title: _eventController.text,
                      date: eventDateTime,
                      priest: _priestController.text,
                      lectors: _lectorsController.text,
                      sacristan: _sacristanController.text,
                      address: _addressController.text,
                      details: _detailsController.text,
                    );

                    if (selectedEvents[selectedDate] != null) {
                      selectedEvents[selectedDate]?.add(event);
                    } else {
                      selectedEvents[selectedDate] = [event];
                    }
                    Navigator.pop(context);
                    _eventController.clear();
                    _priestController.clear();
                    _lectorsController.clear();
                    _sacristanController.clear();
                    _addressController.clear();
                    _detailsController.clear();
                    setState(() {
                      _selectedTime = null;
                    });
                  }
                },
                child: Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildEventList() {
    return _getEventsFromDay(selectedDate).map((Event event) {
      final formattedDate = DateFormat('MMMM d, y').format(event.date);
      final formattedTime = DateFormat('h:mm a').format(event.date);
      return ListTile(
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate), // Display event date
            Text(formattedTime), // Display event time
          ],
        ),
      );
    }).toList();
  }
}
