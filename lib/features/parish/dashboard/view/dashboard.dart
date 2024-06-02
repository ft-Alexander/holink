import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/parish/financial/view/financial_transactions.dart';
import 'package:holink/features/parish/profile/view/profile.dart';
import 'package:holink/features/parish/scheduling/constants/schedule_navbar.dart';
import 'package:holink/features/parish/scheduling/view/ministry.dart';
import 'package:holink/features/parish/scheduling/view/scheduling.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndexBotNav = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('DASHBOARD'),
      ),
      bottomNavigationBar: BottomNavBarParish(
        selectedIndex: _selectedIndexBotNav,
        onTabSelected: _onBotNavSelected,
      ),
    );
  }
}
