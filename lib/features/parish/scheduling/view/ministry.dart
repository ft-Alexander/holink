import 'package:flutter/material.dart';
import 'package:holink/constants/bottom_nav_parish.dart';
import 'package:holink/features/parish/financial/view/financial_transactions.dart';
import 'package:holink/features/parish/scheduling/constants/schedule_navbar.dart';
import 'package:holink/features/parish/scheduling/view/scheduling.dart';

class MinistriesScreen extends StatefulWidget {
  const MinistriesScreen({super.key});

  @override
  State<MinistriesScreen> createState() => _MinistriesScreenState();
}

class _MinistriesScreenState extends State<MinistriesScreen> {
  int _selectedIndexAppBar = 1;
  int _selectedIndexBotNav = 1;

  final Map<int, Widget> appBarRoutes = {
    0: Scheduling(),
    1: MinistriesScreen(),
  };

  final Map<int, Widget> bottomNavBarRoutes = {
    0: TransactionsPage(),
    1: Scheduling(),
    2: TransactionsPage(),
    3: TransactionsPage(),
  };
  void _navigateTo(int index, BuildContext context, Map<int, Widget> routes) {
    if (routes.containsKey(index)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routes[index]!),
      );
    }
  }

  void _onAppBarSelected(int index, BuildContext context) {
    setState(() {
      _selectedIndexAppBar = index;
    });
    _navigateTo(index, context, appBarRoutes);
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
      appBar: CustomNavBar(
        selectedIndex: _selectedIndexAppBar,
        onTabSelected: _onAppBarSelected,
      ),
      body: Center(
        child: Text('Ministries'),
      ),
      bottomNavigationBar: BottomNavBarParish(
        selectedIndex: _selectedIndexBotNav,
        onTabSelected: _onBotNavSelected,
      ),
    );
  }
}
