import 'dart:math';
import 'package:flutter/material.dart';
import 'package:holink/features/scheduling/controllers/events.dart';
import 'package:table_calendar/table_calendar.dart';

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
                Container(
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

                        // style
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
                            border: Border.all(
                                color: Color.fromRGBO(179, 120, 64, 1.0)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          formatButtonTextStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                //outside of the calendar
                const SizedBox(height: 16.0), // Add some spacing
                const Row(
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
                ),
                SizedBox(height: 16.0), // Add some spacing
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                title: Text('Add Event'),
                                content: TextFormField(
                                  controller: _eventController,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        if (_eventController.text.isEmpty) {
                                        } else {
                                          if (selectedEvents[selectedDate] !=
                                              null) {
                                            selectedEvents[selectedDate]?.add(
                                                Event(
                                                    title:
                                                        _eventController.text));
                                          } else {
                                            selectedEvents[selectedDate] = [
                                              Event(
                                                  title: _eventController.text)
                                            ];
                                          }
                                        }
                                        Navigator.pop(context);
                                        _eventController.clear();
                                        setState(() {});
                                        return;
                                      },
                                      child: Text("Save"))
                                ])),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(3.0), // Border radius
                      ),
                      backgroundColor:
                          Color(0xFF57CA63), // Button background color
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0), // Smaller button height
                    ),
                    child: Text(
                      'Add Event',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ),
                ..._getEventsFromDay(selectedDate)
                    .map((Event event) => ListTile(
                          title: Text(event.title),
                        ))
                // Add other widgets here if needed
              ],
            )),
      ),
    );
  }
}
