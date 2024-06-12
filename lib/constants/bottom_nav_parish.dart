import 'package:flutter/material.dart';
import 'package:holink/features/parish/dashboard/view/dashboard.dart';
import 'package:holink/features/parish/financial/view/financial_transactions.dart';
import 'package:holink/features/parish/profile/view/profile.dart';
import 'package:holink/features/parish/scheduling/view/scheduling.dart';

class BottomNavBarParish extends StatelessWidget {
  final int selectedIndex;

  BottomNavBarParish({super.key, required this.selectedIndex});

  final Map<int, Widget> bottomNavBarRoutes = {
    0: const Dashboard(),
    1: const Scheduling(),
    2: const TransactionsPage(),
    3: const ProfileScreen(),
  };

  void _navigateTo(int index, BuildContext context) {
    if (bottomNavBarRoutes.containsKey(index)) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => bottomNavBarRoutes[index]!),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          currentIndex: selectedIndex,
          onTap: (index) => _navigateTo(index, context),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30.0, // Increase the size of the icons
                color: selectedIndex == 0
                    ? const Color.fromRGBO(179, 120, 64, 1.0)
                    : Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                size: 30.0, // Increase the size of the icons
                color: selectedIndex == 1
                    ? const Color.fromRGBO(179, 120, 64, 1.0)
                    : Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                size: 30.0, // Increase the size of the icons
                color: selectedIndex == 2
                    ? const Color.fromRGBO(179, 120, 64, 1.0)
                    : Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30.0, // Increase the size of the icons
                color: selectedIndex == 3
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
    );
  }
}
