import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('DASHBOARD'),
      ),
      bottomNavigationBar: BottomNavBarParish(
        selectedIndex: 0,
      ),
    );
  }
}
