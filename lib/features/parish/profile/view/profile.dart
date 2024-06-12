import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/authentication/views/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                    subtitle: Text('St. John Tha Baptist'),
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
      bottomNavigationBar: BottomNavBarParish(
        selectedIndex: 3,
      ),
    );
  }
}
