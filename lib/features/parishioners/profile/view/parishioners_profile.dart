import 'package:flutter/material.dart';
import 'package:holink/features/authentication/views/login.dart';
import 'package:holink/features/parishioners/service_availment/view/service.dart'; // Import your service screen

class ParishionersProfileScreen extends StatefulWidget {
  const ParishionersProfileScreen({super.key});

  @override
  State<ParishionersProfileScreen> createState() =>
      _ParishionersProfileScreenState();
}

class _ParishionersProfileScreenState extends State<ParishionersProfileScreen> {
  int _selectedIndexBotNav = 3;

  final Map<int, Widget> bottomNavBarRoutes = {
    0: Scaffold(
        body: Center(child: Text("Dashboard"))), // Blank screen for Dashboard
    1: Service(), // Service screen
    2: Scaffold(
        body: Center(child: Text("Finance"))), // Blank screen for Finance
    3: ParishionersProfileScreen(), // Profile screen
  };

  void _navigateTo(int index, BuildContext context, Map<int, Widget> routes) {
    if (routes.containsKey(index)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routes[index]!),
      );
    }
  }

  void _onBotNavSelected(int index, BuildContext context) {
    setState(() {
      _selectedIndexBotNav = index;
    });
    _navigateTo(index, context, bottomNavBarRoutes);
  }

  void _logout(BuildContext context) {
    // Perform logout operations here (e.g., clear session data)

    // Navigate back to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Login()), // Replace with your login screen widget
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/profile_picture.png'), // Replace with your image asset path
            ),
            SizedBox(height: 16),
            Text(
              'JaneDoe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'janedoe@unc.edu.ph',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFB37840), // Border color
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text('LOCATION'),
                    subtitle: Text('St. John The Baptist'),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('CHANGE PASSWORD'),
                    subtitle: Text('********'),
                  ),
                  Divider(),
                  ListTile(
                    title: Center(child: Text('LOGOUT')),
                    onTap: () => _logout(context), // Call the logout function
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80.0, // Increase the height of the container
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFB37840), // Border color
              width: 5.0, // Border width
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              spreadRadius: 2.0,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndexBotNav,
            onTap: (index) => _onBotNavSelected(index, context),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30.0, // Increase the size of the icons
                  color: _selectedIndexBotNav == 0
                      ? Color.fromRGBO(179, 120, 64, 1.0)
                      : Colors.grey,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_today,
                  size: 30.0, // Increase the size of the icons
                  color: _selectedIndexBotNav == 1
                      ? Color.fromRGBO(179, 120, 64, 1.0)
                      : Colors.grey,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                  size: 30.0, // Increase the size of the icons
                  color: _selectedIndexBotNav == 2
                      ? Color.fromRGBO(179, 120, 64, 1.0)
                      : Colors.grey,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 30.0, // Increase the size of the icons
                  color: _selectedIndexBotNav == 3
                      ? Color.fromRGBO(179, 120, 64, 1.0)
                      : Colors.grey,
                ),
                label: '',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Color.fromRGBO(179, 120, 64, 1.0),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
