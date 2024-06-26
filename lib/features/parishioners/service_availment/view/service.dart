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
  String selectedChurch = "St. John the Baptist";
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
    0: const Scaffold(
        body: Center(child: Text("Dashboard"))), // Blank screen for Dashboard
    1: const Service(), // Service screen
    2: const Scaffold(
        body: Center(child: Text("Finance"))), // Blank screen for Finance
    3: const ParishionersProfileScreen(), // Profile screen
  };

  void _selectChurch(String church) {
    setState(() {
      selectedChurch = church;
    });
  }

  Widget _buildCalendar() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
        height: MediaQuery.of(context).size.height * 0.6, // Adjust the height as needed
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color.fromRGBO(179, 120, 64, 1.0),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding inside the containers
          child: SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
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
                      border: Border.all(color: const Color.fromRGBO(179, 120, 64, 1.0)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    formatButtonTextStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
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
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            title: Text(
              selectedChurch,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0, // Adjustable font size
                fontWeight: FontWeight.bold, // Font weight
                
              ),
            ),
            centerTitle: true, // Center the title
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30.0), // Adjust the height as needed
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(                  
                    color: Color.fromRGBO(179, 120, 64, 1.0),
                  ),
                  child: Text(
                    'Select Church',
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ),
                ListTile(
                  title: const Text('St. Joseph the Worker Parish'),
                  onTap: () {
                    _selectChurch('St. Joseph the Worker Parish');
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  title: const Text('St. John the Baptist'),
                  onTap: () {
                    _selectChurch('St. John the Baptist');
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  title: const Text('St. Michael the Archangel Parish'),
                  onTap: () {
                    _selectChurch('St. Michael the Archangel Parish');
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  title: const Text('St. James the Greater Apostle Cathedral Parish'),
                  onTap: () {
                    _selectChurch('St. James the Greater Apostle Cathedral Parish');
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  title: const Text('Our Lady of the Pillar Parish and Shrine'),
                  onTap: () {
                    _selectChurch('Our Lady of the Pillar Parish and Shrine');
                    Navigator.pop(context); // Close the drawer
                  },
                ),
              ],
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
                            backgroundColor: const Color.fromRGBO(179, 120, 64, 1.0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
