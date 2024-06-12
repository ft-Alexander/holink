import 'package:flutter/material.dart';
import 'package:holink/features/parish/scheduling/view/ministry.dart';
import 'package:holink/features/parish/scheduling/view/scheduling.dart';
// Assuming MinistriesScreen is in this path

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;

  CustomNavBar({super.key, required this.selectedIndex});

  final Map<int, Widget> appBarRoutes = {
    0: const Scheduling(),
    1: const MinistriesScreen(),
  };

  void _navigateTo(int index, BuildContext context) {
    if (appBarRoutes.containsKey(index)) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => appBarRoutes[index]!),
        (route) => false,
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          _buildTabItem(
            context: context,
            index: 0,
            title: 'EVENTS',
            isSelected: selectedIndex == 0,
            onTap: _navigateTo,
          ),
          const Spacer(),
          Stack(
            children: [
              _buildTabItem(
                context: context,
                index: 1,
                title: 'MINISTRIES',
                isSelected: selectedIndex == 1,
                onTap: _navigateTo,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required int index,
    required String title,
    required bool isSelected,
    required Function(int, BuildContext) onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(index, context),
      child: Container(
        width:
            MediaQuery.of(context).size.width / 3, // Adjust width for spacing
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? const Color.fromRGBO(179, 120, 64, 1.0)
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
