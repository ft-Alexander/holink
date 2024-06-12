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
    0: const Scaffold(
        body: Center(child: Text("Dashboard"))), // Blank screen for Dashboard
    1: const Service(), // Service screen
    2: const Scaffold(
        body: Center(child: Text("Finance"))), // Blank screen for Finance
    3: const ParishionersProfileScreen(), // Profile screen
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
              const Login()), // Replace with your login screen widget
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
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/profile_picture.png'), // Replace with your image asset path
            ),
            const SizedBox(height: 16),
            const Text(
              'JaneDoe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'janedoe@unc.edu.ph',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFB37840), // Border color
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const ListTile(
                    title: Text('LOCATION'),
                    subtitle: Text('St. John The Baptist'),
                  ),
                  const Divider(),
                  const ListTile(
                    title: Text('CHANGE PASSWORD'),
                    subtitle: Text('********'),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Center(child: Text('LOGOUT')),
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
        decoration: const BoxDecoration(
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
          borderRadius: const BorderRadius.only(
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
                      ? const Color.fromRGBO(179, 120, 64, 1.0)
                      : Colors.grey,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_today,
                  size: 30.0, // Increase the size of the icons
                  color: _selectedIndexBotNav == 1
                      ? const Color.fromRGBO(179, 120, 64, 1.0)
                      : Colors.grey,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                  size: 30.0, // Increase the size of the icons
                  color: _selectedIndexBotNav == 2
                      ? const Color.fromRGBO(179, 120, 64, 1.0)
                      : Colors.grey,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 30.0, // Increase the size of the icons
                  color: _selectedIndexBotNav == 3
                      ? const Color.fromRGBO(179, 120, 64, 1.0)
                      : Colors.grey,
                ),
                label: '',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color.fromRGBO(179, 120, 64, 1.0),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
