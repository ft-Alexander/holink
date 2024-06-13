import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/parish/scheduling/constants/schedule_navbar.dart';
import 'package:holink/features/parish/scheduling/services/plot_regular_event.dart';
import 'package:holink/features/parish/scheduling/services/event_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:holink/features/parish/scheduling/model/regularEvent.dart';
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
  EventService _eventService = EventService();
  Map<DateTime, List<RegularEventDate>> _events = {};
  List<RegularEventDate> _selectedEvents = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchEvents();
  // }

  // Future<void> _fetchEvents() async {
  //   List<RegularEvent> events = await _eventService.fetchRegularEvents();
  //   print('Fetched events: $events');
  //   try {
  //     setState(() {
  //       _events = _mapEventsToDates(events);
  //     });

  //     // Print statements to debug fetched events
  //     for (var event in events) {
  //       print(
  //           'Event: ${event.eventName}, Description: ${event.description}, Address: ${event.address}');
  //       for (var eventDate in event.eventDates) {
  //         print(
  //             'Event Date ID: ${eventDate.id}, Date: ${eventDate.eventDate}, Priest ID: ${eventDate.priestId}, Lector ID: ${eventDate.lectorId}, Sacristan ID: ${eventDate.sacristanId}, Archive Status: ${eventDate.archiveStatus}');
  //       }
  //     }
  //     // Print the events map
  //     _events.forEach((date, events) {
  //       print('Date: $date, Events: $events');
  //     });
  //   } catch (e) {
  //     print('Failed to load events: $e');
  //   }
  // }

  Map<DateTime, List<RegularEventDate>> _mapEventsToDates(
      List<RegularEvent> events) {
    final Map<DateTime, List<RegularEventDate>> mappedEvents = {};
    for (var event in events) {
      for (var eventDate in event.eventDates) {
        final date = DateTime(eventDate.eventDate.year,
            eventDate.eventDate.month, eventDate.eventDate.day);
        if (mappedEvents[date] == null) {
          mappedEvents[date] = <RegularEventDate>[];
        }
        mappedEvents[date]!.add(eventDate);
      }
    }
    return mappedEvents;
  }

  List<RegularEventDate> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  List<Color> _getEventDotColors(List<RegularEventDate> events) {
    List<Color> colors = [];
    for (var event in events) {
      colors.add(Colors.green); // Regular event color
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(
        selectedIndex: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildCalendar(),
              const SizedBox(height: 16.0),
              _buildAddEventButton(context),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarParish(
        selectedIndex: 1,
      ),
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
              _selectedEvents = _getEventsForDay(selectedDay);
            });
          },
          selectedDayPredicate: (date) {
            return isSameDay(selectedDate, date);
          },
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
              List<Color> colors =
                  _getEventDotColors(events as List<RegularEventDate>);
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
      ),
    );
  }

  Widget _buildAddEventButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegularEventForm()),
        );
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
