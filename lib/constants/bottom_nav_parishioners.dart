// bottom_navbar_parishioners.dart
import 'package:flutter/material.dart';

class BottomNavBarParishioners extends StatelessWidget {
  final int selectedIndex;
  final Function(int, BuildContext) onTabSelected;

  const BottomNavBarParishioners(
      {super.key, required this.selectedIndex, required this.onTabSelected});

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
          onTap: (index) => onTabSelected(index, context),
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
