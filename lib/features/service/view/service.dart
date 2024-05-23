import 'package:flutter/material.dart';
import 'package:holink/features/service/view/serviceWidget/service_information.dart'; // Service information
import 'package:holink/features/scheduling/view/scheduling.dart'; // Import the Scheduling widget
import 'package:holink/features/service/controllers/userAgreement.dart'; // Import the User Agreement widget
import 'package:holink/features/service/view/view_edit_service/ViewEditInformation.dart'; // Import the ViewEditInformation widget
import 'package:holink/features/service/view/cancel_service/Cancel_Availed_Service.dart'; // Import the CancelAvailedService widget

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
                icon: Icon(Icons.notifications),
                onPressed: () {},
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: const Color.fromARGB(255, 3, 3, 3),
              tabs: [
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
                    
                    SizedBox(height: 8.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("View Schedules"),
                      ),
                    ),
                    Spacer(), // Push the buttons to the bottom
                    // Buttons at the bottom with gaps and arrows
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        children: [
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the UserAgreement page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const UserAgreement()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(400, 60), // Adjust the width and height as needed
                                alignment: Alignment.centerLeft, // Align text to the left
                                padding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding
                                side: BorderSide(width: 1.0, color: Colors.black), // Border
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                textStyle: TextStyle(color: Color.fromARGB(255, 16, 16, 16)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "AVAIL CHURCH SERVICE",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ), // Change font color here
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the ViewEditInformation page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ViewEditInformation()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(400, 60), // Adjust the width and height as needed
                                alignment: Alignment.centerLeft, // Align text to the left
                                padding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding
                                side: BorderSide(width: 1.0, color: Colors.black), // Border
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "VIEW/EDIT AVAILED SERVICE INFORMATION",
                                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the CancelAvailedService page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CancelAvailedService()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                fixedSize: Size(400, 60), // Adjust the width and height as needed
                                alignment: Alignment.centerLeft, // Align text to the left
                                padding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding
                                side: BorderSide(width: 1.0, color: Colors.black), // Border
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "CANCEL SERVICE",
                                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Call the ServiceInformation widget here
              ServiceInformation(),
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
