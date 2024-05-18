import 'package:flutter/material.dart';
import 'package:holink/features/scheduling/controllers/events.dart';
import 'package:holink/features/scheduling/view/add_new_event.dart';
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

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[DateTime(date.year, date.month, date.day)] ?? [];
  }

  @override
  void dispose() {
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

  void _onSaveEvent(DateTime eventDateTime, String title, String priest,
      String lectors, String sacristan, String address, String details) {
    final event = Event(
      title: title,
      date: eventDateTime,
      priest: priest,
      lectors: lectors,
      sacristan: sacristan,
      address: address,
      details: details,
    );

    setState(() {
      if (selectedEvents[selectedDate] != null) {
        selectedEvents[selectedDate]?.add(event);
      } else {
        selectedEvents[selectedDate] = [event];
      }
    });
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
