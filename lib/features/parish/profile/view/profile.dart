import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/authentication/views/login.dart';
import 'package:holink/features/parish/dashboard/view/dashboard.dart';
import 'package:holink/features/parish/financial/view/financial_transactions.dart';
import 'package:holink/features/parish/scheduling/view/scheduling.dart'; // Replace with your login screen import

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndexBotNav = 3;

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
                    subtitle: Text('St. John Tha Baptist'),
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
      bottomNavigationBar: BottomNavBarParish(
        selectedIndex: _selectedIndexBotNav,
        onTabSelected: _onBotNavSelected,
      ),
    );
  }
}
