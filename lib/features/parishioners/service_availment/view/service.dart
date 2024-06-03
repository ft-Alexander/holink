import 'package:flutter/material.dart';
import 'package:holink/features/parishioners/service_availment/view/serviceWidget/service_information.dart'; // Service information
import 'package:holink/features/parish/scheduling/view/scheduling.dart'; // Import the Scheduling widget
import 'package:holink/features/parishioners/profile/view/parishioners_profile.dart'; // Import the ParishionersProfileScreen
import 'package:holink/constants/bottom_nav_parishioners.dart'; // Import the BottomNavBarParishioners
import 'service_operations.dart'; // Import the BottomButtons widget

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDate = day;
    });
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
    0: Scaffold(body: Center(child: Text("Dashboard"))), // Blank screen for Dashboard
    1: Service(), // Service screen
    2: Scaffold(body: Center(child: Text("Finance"))), // Blank screen for Finance
    3: ParishionersProfileScreen(), // Profile screen
  };

  Widget _getSelectedWidget() {
    switch (_selectedIndex) {
      case 0:
        return const Scheduling();
      case 1:
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30.0), // Adjust the height as needed
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: const Color.fromARGB(255, 3, 3, 3),
                labelStyle: TextStyle(
                  fontSize: 14.0, // Adjust font size
                  fontWeight: FontWeight.normal, // Adjust font weight
                ),
                unselectedLabelStyle: TextStyle(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none, // Ensure overflow is visible
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0), // Adjust the position of the image
                            child: Image.asset(
                              'PCalendar.png', // Use the correct path to your placeholder image
                              height: 298,
                              width: 331,
                            ),
                          ),
                          Positioned(
                            top: 13, // Adjust the vertical position
                            left: 10, // Adjust the horizontal position
                            child: SizedBox(
                              height: 38, // Adjust this value to control the height
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedChurch,
                                    icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white), // Adjust icon color
                                    iconSize: 20,
                                    elevation: 16,
                                    style: const TextStyle(color: Color.fromARGB(255, 249, 248, 248), fontSize: 10),
                                    dropdownColor: Colors.green[600], // Color of the dropdown menu
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedChurch = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'St. John the Baptist (San Fernando)',
                                      'St. Peter\'s Church',
                                      'St. Mary\'s Cathedral'
                                    ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -25, // Adjust the vertical position to ensure visibility
                            left: 40, // Adjust the horizontal position
                            right: 40, // Adjust the horizontal position
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Scheduling()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[600], // Background color
                                  padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10), // Button padding
                                  textStyle: TextStyle(fontSize: 10), // Font size
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0), // Border radius
                                    side: BorderSide(color: Colors.grey), // Border color
                                  ),
                                ),
                                child: const Text(
                                  "View Schedules",
                                  style: TextStyle(color: Colors.white), // Font color
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Spacer(), // Push the buttons to the bottom
                    const BottomButtons(), // Call the BottomButtons widget here
                  ],
                ),
              ),
              // Call the ServiceInformation widget here
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
