import 'package:flutter/material.dart';

class ServiceInformation extends StatelessWidget {
  const ServiceInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        ExpansionTile(
          title: Text("Baptism"),
          children: [
            ListTile(
              title: Text(
                "Description of the Baptism service...",
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Wedding"),
          children: [
            ListTile(
              title: Text(
                "Description of the Wedding service...",
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Confirmation"),
          children: [
            ListTile(
              title: Text(
                "Description of the Confirmation service...",
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Mass for the Dead"),
          children: [
            ListTile(
              title: Text(
                "Description of the Mass for the Dead service...",
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Blessing"),
          children: [
            ListTile(
              title: Text(
                "Description of the Blessing service...",
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("First Holy Communion"),
          children: [
            ListTile(
              title: Text(
                "Description of the First Holy Communion service...",
              ),
            ),
          ],
        ),
      ],
    );
  }
}