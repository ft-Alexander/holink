import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/parish/scheduling/constants/schedule_navbar.dart';
import 'package:holink/features/parish/scheduling/model/get_all_event.dart';
import 'package:holink/features/parish/scheduling/services/event_card.dart';
import 'package:holink/features/parish/scheduling/services/event_service.dart';
import 'package:holink/features/parish/scheduling/services/plot_regular_event.dart';
import 'package:table_calendar/table_calendar.dart';

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
  Map<DateTime, List<FetchEvents>> _events = {};
  List<FetchEvents> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetEvents();
  }

  Future<void> fetchAndSetEvents() async {
    try {
      List<FetchEvents> events =
          await _eventService.fetchAllRegularEventDates();
      setState(() {
        _events = {};
        for (var event in events) {
          final date = DateTime(event.eventDate!.year, event.eventDate!.month,
              event.eventDate!.day);
          if (_events[date] != null) {
            _events[date]!.add(event);
          } else {
            _events[date] = [event];
          }
        }
        // Set _selectedEvents for the initially selected date
        _selectedEvents = _getEventsForDay(selectedDate);
      });
    } catch (error) {
      print('Error fetching events: $error');
    }
  }

  List<FetchEvents> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _refreshEvents() {
    // Fetch and update the events after cancellation
    fetchAndSetEvents();
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
            Align(
              alignment: Alignment.centerLeft,
              child: _buildAddEventButton(context),
            ),
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
              final uniqueEventTypes = events.map((event) {
                final fetchEvent = event as FetchEvents;
                return fetchEvent.eventType;
              }).toSet();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: uniqueEventTypes.map((eventType) {
                  Color color;
                  switch (eventType) {
                    case 'Regular':
                      color = Colors.green;
                      break;
                    case 'Mass':
                      color = Colors.orange;
                      break;
                    case 'Special':
                      color = Colors.brown;
                      break;
                    default:
                      color = Colors.grey;
                  }
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
      ),
    );
  }

  Widget _buildEventsList() {
    if (_selectedEvents.isEmpty) {
      return const Center(
        child: Text(
          'NO SCHEDULED EVENT',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return Column(
      children: _selectedEvents
          .map((event) => EventCard(
                event: event,
                onAddPerson: () {
                  // Add person functionality
                },
                onEdit: () {
                  // Edit information functionality
                },
                onCancel: () {
                  // Call _refreshEvents to update the state
                  _refreshEvents();
                },
              ))
          .toList(),
    );
  }

  Widget _buildAddEventButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegularEventForm(
                onEventAdded: fetchAndSetEvents), // Modify this line
          ),
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
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      ),
      child: const Text(
        'Plot Regular Events',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }
}
