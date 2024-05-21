import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/features/scheduling/model/events.dart';
import 'package:holink/features/scheduling/view/add_new_event_regular.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
    fetchAndSetEvents();
  }

  Future<List<Event>> fetchEvents() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.13/dashboard/myfolder/getEvents.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<void> fetchAndSetEvents() async {
    try {
      final events = await fetchEvents();
      setState(() {
        selectedEvents = {};
        for (var event in events) {
          final date =
              DateTime(event.date.year, event.date.month, event.date.day);
          if (selectedEvents[date] != null) {
            selectedEvents[date]!.add(event);
          } else {
            selectedEvents[date] = [event];
          }
        }
      });
    } catch (error) {
      print('Error fetching events: $error');
    }
  }

  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[DateTime(date.year, date.month, date.day)] ?? [];
  }

  List<Color> _getEventDotColors(List<Event> events) {
    final eventTypes = events.map((e) => e.event_type).toSet();
    List<Color> colors = [];

    if (eventTypes.contains('Regular')) {
      colors.add(Colors.green);
    }
    if (eventTypes.contains('Public')) {
      colors.add(Colors.brown);
    }
    if (eventTypes.contains('Private')) {
      colors.add(Colors.orange);
    }
    return colors;
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
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding inside the container
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
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox.shrink();
                  List<Color> colors =
                      _getEventDotColors(events as List<Event>);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: colors.map((color) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                        width: 8.0,
                        height: 8.0,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEventScreen(
              selectedDate: selectedDate,
              onSave: _onSaveEvent,
            ),
          ),
        ),
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

  void _onSaveEvent(
      DateTime eventDateTime,
      String title,
      String priest,
      String lectors,
      String sacristan,
      String address,
      String details,
      String sacraments,
      String event_type) {
    final event = Event(
      title: title,
      date: eventDateTime,
      priest: priest,
      lectors: lectors,
      sacristan: sacristan,
      address: address,
      details: details,
      sacraments: sacraments,
      event_type: event_type,
    );

    setState(() {
      final date =
          DateTime(eventDateTime.year, eventDateTime.month, eventDateTime.day);
      if (selectedEvents[date] != null) {
        selectedEvents[date]?.add(event);
      } else {
        selectedEvents[date] = [event];
      }
    });
  }

  List<Widget> _buildEventList() {
    // Get the events for the selected day
    List<Event> events = _getEventsFromDay(selectedDate);
    // Sort the events by time
    events.sort((a, b) => a.date.compareTo(b.date));

    return events.map((Event event) {
      final formattedDate = DateFormat('MMMM d, y').format(event.date);
      final formattedTime = DateFormat('h:mm a').format(event.date);
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown.shade200),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(formattedDate),
                  Text(formattedTime),
                  SizedBox(height: 5),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: _getEventTypeColor(event.event_type),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      event.event_type,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    // Edit event action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete event action
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getEventTypeColor(String eventType) {
    switch (eventType) {
      case 'Regular':
        return Colors.green;
      case 'Public':
        return Colors.brown;
      case 'Private':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
