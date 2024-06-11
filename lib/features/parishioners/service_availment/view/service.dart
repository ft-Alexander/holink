import 'package:flutter/material.dart';
import 'package:holink/features/parishioners/service_availment/view/serviceWidget/service_information.dart';
import 'package:holink/features/parishioners/profile/view/parishioners_profile.dart';
import 'package:holink/constants/bottom_nav_parishioners.dart';
import 'package:table_calendar/table_calendar.dart';
import 'service_operations.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> with SingleTickerProviderStateMixin {
  String selectedChurch = "St. John the Baptist (San Fernando)";
  DateTime selectedDate = DateTime.now();
  late TabController _tabController;
  int _selectedIndex = 1; // Set default index to 1 for Service tab
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => bottomNavBarRoutes[index]!),
    );
  }

  final Map<int, Widget> bottomNavBarRoutes = {
    0: Scaffold(
        body: Center(child: Text("Dashboard"))), // Blank screen for Dashboard
    1: const Service(), // Service screen
    2: Scaffold(
        body: Center(child: Text("Finance"))), // Blank screen for Finance
    3: const ParishionersProfileScreen(), // Profile screen
  };

  Widget _buildCalendar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromRGBO(179, 120, 64, 1.0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0), // Add padding inside the container
        child: TableCalendar(
          focusedDay: selectedDate,
          firstDay: DateTime(1990),
          lastDay: DateTime(2050),
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          daysOfWeekVisible: true,
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
            markersMaxCount: 1,
            markerSizeScale: 0.4,
            cellMargin: EdgeInsets.all(4.0),
            markersAlignment: Alignment.bottomCenter,
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
        ),
      ),
    );
  }

  Widget _getSelectedWidget() {
    switch (_selectedIndex) {
      case 0:
        return const Scaffold(
          body: Center(child: Text("Dashboard")),
        );
      case 1:
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [             
            ],
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(30.0), // Adjust the height as needed
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: const Color.fromARGB(255, 3, 3, 3),
                labelStyle: const TextStyle(
                  fontSize: 14.0, // Adjust font size
                  fontWeight: FontWeight.normal, // Adjust font weight
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14.0, // Adjust font size
                  fontWeight: FontWeight.normal, // Adjust font weight
                ),
                tabs: const [
                  Tab(text: 'SERVICE AVAILMENT'),
                  Tab(text: 'SERVICE INFORMATION'),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCalendar(),
                      const SizedBox(height: 8.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement your navigation logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(179, 120, 64, 1.0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            "View Activities",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0, // Adjust font size
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const BottomButtons(), // Use BottomButtons here
                    ],
                  ),
                ),
              ),
              const ServiceInformation(),
            ],
          ),
        );
      default:
        return const Center(child: Text("Page not found"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedWidget(),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBarParishioners(
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
      ),
    );
  }
}
