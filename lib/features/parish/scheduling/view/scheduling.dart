import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/parish/dashboard/view/dashboard.dart';
import 'package:holink/features/parish/financial/view/financial_transactions.dart';
import 'package:holink/features/parish/profile/view/profile.dart';
import 'package:holink/features/parish/scheduling/constants/schedule_navbar.dart';
import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/parish/scheduling/model/getEvent_pub_reg.dart';
import 'package:holink/features/parish/scheduling/services/add_new_event.dart';
import 'package:holink/features/parish/scheduling/services/edit_schedule.dart';
import 'package:holink/features/parish/scheduling/services/viewEvent.dart';
import 'package:holink/features/parish/scheduling/services/viewPrivateEvent.dart';
import 'package:holink/features/parish/scheduling/view/ministry.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Scheduling extends StatefulWidget {
  const Scheduling({super.key});

  @override
  State<Scheduling> createState() => _SchedulingState();
}

class _SchedulingState extends State<Scheduling> {
  late Map<DateTime, List<getEvent>> selectedEvents;
  DateTime focusedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  localhost localhostInstance = localhost();

  int _selectedIndexAppBar = 0;
  int _selectedIndexBotNav = 1;

  final Map<int, Widget> appBarRoutes = {
    0: Scheduling(),
    1: MinistriesScreen(),
  };

  final Map<int, Widget> bottomNavBarRoutes = {
    0: Dashboard(),
    1: Scheduling(),
    2: TransactionsPage(),
    3: ProfileScreen(),
  };

  void _navigateTo(int index, BuildContext context, Map<int, Widget> routes) {
    if (routes.containsKey(index)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routes[index]!),
      );
    }
  }

  void _onAppBarSelected(int index, BuildContext context) {
    setState(() {
      _selectedIndexAppBar = index;
    });
    _navigateTo(index, context, appBarRoutes);
  }

  void _onBotNavSelected(int index, BuildContext context) {
    setState(() {
      _selectedIndexBotNav = index;
    });
    _navigateTo(index, context, bottomNavBarRoutes);
  }

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
    fetchAndSetEvents();
  }

  Future<List<getEvent>> fetchEvents() async {
    final response = await http.get(Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/getEvents.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => getEvent.fromJson(json)).toList();
    } else {
      print('Failed to fetch events. Status code: ${response.statusCode}');
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

  List<getEvent> _getEventsFromDay(DateTime date) {
    return selectedEvents[DateTime(date.year, date.month, date.day)] ?? [];
  }

  List<Color> _getEventDotColors(List<getEvent> events) {
    final filteredEvents = events.where((event) {
      return event.archive_status != "archive";
    }).toList();

    final eventTypes = filteredEvents.map((e) => e.event_type).toSet();
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
      appBar: CustomNavBar(
        selectedIndex: _selectedIndexAppBar,
        onTabSelected: _onAppBarSelected,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildCalendar(),
              const SizedBox(height: 16.0),
              _buildLegend(),
              const SizedBox(height: 16.0),
              _buildAddEventButtons(context),
              ..._buildEventList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarParish(
        selectedIndex: _selectedIndexBotNav,
        onTabSelected: _onBotNavSelected,
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
                      _getEventDotColors(events as List<getEvent>);
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

  Widget _buildAddEventButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            margin:
                EdgeInsets.only(right: 2.0), // Adds space between the buttons
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
          ),
        ),
      ],
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
      String event_type,
      String archive_status) {
    final event = getEvent(
        s_id: 0, // Use a temporary ID, will be replaced by actual ID from DB
        title: title,
        date: eventDateTime,
        priest: priest,
        lectors: lectors,
        sacristan: sacristan,
        address: address,
        details: details,
        sacraments: sacraments,
        event_type: event_type,
        archive_status: archive_status);

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
    List<getEvent> events = _getEventsFromDay(selectedDate);
    List<getEvent> filteredEvents =
        events.where((event) => event.archive_status != "archive").toList();
    filteredEvents.sort((a, b) => a.date.compareTo(b.date));

    if (filteredEvents.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // Add top padding
          child: Center(
            child: Text(
              "NO SCHEDULED EVENTS",
              style: TextStyle(
                fontSize: 24.0,
                color: Color(0xFF959595),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ];
    }

    return filteredEvents.map((getEvent event) {
      final formattedDate = DateFormat('MMMM d, y').format(event.date);
      final formattedTime = DateFormat('h:mm a').format(event.date);
      String displayTitle = event.event_type == 'Private'
          ? 'Private: ${event.sacraments}'
          : event.title;

      return GestureDetector(
        onTap: () async {
          if (event.event_type == 'Private') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ViewPrivateScreen(event: event);
              },
            ).then((result) {
              if (result == true) {
                fetchAndSetEvents();
              }
            });
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ViewEventScreen(event: event);
              },
            ).then((result) {
              if (result == true) {
                fetchAndSetEvents();
              }
            });
          }
        },
        child: Container(
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
                      displayTitle,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  if (event.event_type != 'Private')
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.green),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditScheduleScreen(event: event),
                          ),
                        );
                        if (result == true) {
                          fetchAndSetEvents();
                        }
                      },
                    ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      if (event.event_type == 'Private') {
                        await _archivePrivate(event);
                      } else {
                        await _archiveEvent(event);
                      }
                      fetchAndSetEvents();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Future<void> _archiveEvent(getEvent event) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/archiveStatus.php'),
        body: json.encode(event.toMap()),
      );

      if (response.statusCode == 200) {
        print('Event updated successfully');
      } else {
        print('Failed to update event. Status code: ${response.statusCode}');
        throw Exception('Failed to update event');
      }
    } catch (error) {
      print('Error updating event: $error');
      throw error;
    }
  }

  Future<void> _archivePrivate(getEvent event) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/privateEvents.php'),
        body: json.encode(event.toMap()),
      );

      if (response.statusCode == 200) {
        print('Private event archived successfully');
      } else {
        print(
            'Failed to archive private event. Status code: ${response.statusCode}');
        throw Exception('Failed to archive private event');
      }
    } catch (error) {
      print('Error archiving private event: $error');
      throw error;
    }
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
