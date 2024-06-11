import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Function(int, BuildContext) onTabSelected;

  CustomNavBar({required this.selectedIndex, required this.onTabSelected});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          _buildTabItem(
            context: context,
            index: 0,
            title: 'EVENTS',
            isSelected: selectedIndex == 0,
            onTap: onTabSelected,
          ),
          Spacer(),
          Stack(
            children: [
              _buildTabItem(
                context: context,
                index: 1,
                title: 'MINISTRIES',
                isSelected: selectedIndex == 1,
                onTap: onTabSelected,
              ),
            ],
          ),
          Spacer(),
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
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Color.fromRGBO(179, 120, 64, 1.0)
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
