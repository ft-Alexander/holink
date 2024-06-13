import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/parish/scheduling/constants/schedule_navbar.dart';
import 'package:holink/features/parish/scheduling/services/event_service.dart';
import 'package:holink/features/parish/scheduling/services/plot_regular_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:holink/features/parish/scheduling/model/regularEventDate.dart';

class Scheduling extends StatefulWidget {
  const Scheduling({super.key});

  @override
  State<Scheduling> createState() => _SchedulingState();
}

class _SchedulingState extends State<Scheduling> {
  DateTime focusedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final EventService _eventService = EventService();
  Map<DateTime, List<RegularEventDate>> _events = {};
  List<RegularEventDate> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetEvents();
  }

  Future<void> fetchAndSetEvents() async {
    try {
      List<RegularEventDate> events =
          await _eventService.fetchRegularEventDates();
      setState(() {
        _events = {};
        for (var eventDate in events) {
          final date = DateTime(eventDate.eventDate.year,
              eventDate.eventDate.month, eventDate.eventDate.day);
          if (_events[date] != null) {
            _events[date]!.add(eventDate);
          } else {
            _events[date] = [eventDate];
          }
        }
      });
    } catch (error) {
      print('Error fetching events: $error');
    }
  }

  List<RegularEventDate> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(selectedIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 16.0),
            _buildAddEventButton(context),
            const SizedBox(height: 16.0),
            _buildEventsList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarParish(selectedIndex: 1),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromRGBO(179, 120, 64, 1.0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          focusedDay: focusedDate,
          firstDay: DateTime(1990),
          lastDay: DateTime(2050),
          calendarFormat: _calendarFormat,
          eventLoader: _getEventsForDay,
          onFormatChanged: (format) => setState(() {
            _calendarFormat = format;
          }),
          daysOfWeekVisible: true,
          onDaySelected: (selectedDay, focusedDay) => setState(() {
            selectedDate = selectedDay;
            focusedDate = focusedDay;
            _selectedEvents = _getEventsForDay(selectedDay);
            print('Events for $selectedDay: $_selectedEvents');
          }),
          selectedDayPredicate: (date) => isSameDay(selectedDate, date),
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
              color: const Color.fromRGBO(179, 120, 64, 1.0),
              border:
                  Border.all(color: const Color.fromRGBO(179, 120, 64, 1.0)),
              borderRadius: BorderRadius.circular(5.0),
            ),
            formatButtonTextStyle: const TextStyle(color: Colors.white),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return const SizedBox.shrink();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events.map((event) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    width: 8.0,
                    height: 8.0,
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    if (_selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'NO SCHEDULED EVENT',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return Column(
      children: _selectedEvents.map((event) => _buildEventCard(event)).toList(),
    );
  }

  Widget _buildEventCard(RegularEventDate event) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.eventDetails!.eventName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Date: ${event.eventDate.toLocal().toString().split(' ')[0]}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Time: ${event.eventDate.toLocal().toString().split(' ')[1].substring(0, 5)}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Location: ${event.eventDetails!.address}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddEventButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegularEventForm()),
        );
        if (result == true) {
          // Refresh events after adding a new one
          fetchAndSetEvents();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.0),
        ),
        backgroundColor: const Color(0xFF57CA63),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
      ),
      child: const Text(
        'Plot Regular Events',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }
}
