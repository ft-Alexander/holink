import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/parish/scheduling/constants/schedule_navbar.dart';
// Import your new BottomNavBarParish

class MinistriesScreen extends StatefulWidget {
  const MinistriesScreen({super.key});

  @override
  State<MinistriesScreen> createState() => _MinistriesScreenState();
}

class _MinistriesScreenState extends State<MinistriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(
        selectedIndex: 1,
      ),
      body: const Center(
        child: Text('Ministries'),
      ),
      bottomNavigationBar: BottomNavBarParish(
        selectedIndex: 1,
      ),
    );
  }
}
