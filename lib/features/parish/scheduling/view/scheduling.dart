import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/parish/scheduling/constants/schedule_navbar.dart';
import 'package:holink/features/parish/scheduling/services/plot_regular_event.dart';
import 'package:table_calendar/table_calendar.dart'; // Import your RegularEventForm screen here

class Scheduling extends StatefulWidget {
  const Scheduling({super.key});

  @override
  State<Scheduling> createState() => _SchedulingState();
}

class _SchedulingState extends State<Scheduling> {
  DateTime focusedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

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
                  border: Border.all(color: const Color.fromRGBO(179, 120, 64, 1.0)),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ],
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
