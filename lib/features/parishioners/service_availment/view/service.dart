import 'package:flutter/material.dart';
import 'package:holink/features/parishioners/service_availment/view/serviceWidget/service_information.dart'; // Service information
import 'package:holink/features/parish/scheduling/view/scheduling.dart'; // Import the Scheduling widget
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: const Color.fromARGB(255, 3, 3, 3),
              tabs: const [
                Tab(text: 'SERVICE AVAILMENT'),
                Tab(text: 'SERVICE INFORMATION'),
              ],
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
                    DropdownButton<String>(
                      value: selectedChurch,
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
                    const SizedBox(height: 8.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("View Schedules"),
                      ),
                    ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green.withOpacity(0.6),
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Finance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
