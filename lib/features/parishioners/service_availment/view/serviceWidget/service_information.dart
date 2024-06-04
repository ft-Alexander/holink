import 'package:flutter/material.dart';

class ServiceInformation extends StatelessWidget {
  const ServiceInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        buildServiceTile(
          "Wedding",
          "Regular Wedding services are usually held on weekends with specific dates set by the church.",
          "Special Wedding services can be arranged on special request with additional requirements.",
          "Documents Needed: Marriage License, Baptismal and Confirmation Certificates\nNo Service Fees Required.",
          "Documents Needed: Marriage License, Special Request Form, Baptismal and Confirmation Certificates\nAdditional Fees May Apply.",
        ),
        buildServiceTile(
          "Baptism",
          "Regular Baptism services are held on the first Sunday of every month.",
          "Special Baptism services can be scheduled privately with the pastor.",
          "Documents Needed: Birth Certificate, Parent's Baptismal Certificate\nNo Service Fees Required.",
          "Documents Needed: Birth Certificate, Parent's Baptismal Certificate, Special Request Form\nAdditional Fees May Apply.",
        ),
        buildServiceTile(
          "Confirmation",
          "Regular Confirmation services are held annually for all eligible candidates.",
          "Special Confirmation services can be arranged for specific groups upon request.",
          "Documents Needed: Baptismal Certificate, Confirmation Class Completion Certificate\nNo Service Fees Required.",
          "Documents Needed: Baptismal Certificate, Confirmation Class Completion Certificate, Special Request Form\nAdditional Fees May Apply.",
        ),
        buildServiceTile(
          "Mass for the Dead",
          "Regular Mass for the Dead services are held monthly on the last Friday.",
          "Special Mass for the Dead services can be arranged for anniversaries or special remembrances.",
          "Documents Needed: Death Certificate\nNo Service Fees Required.",
          "Documents Needed: Death Certificate, Special Request Form\nAdditional Fees May Apply.",
        ),
        buildServiceTile(
          "Blessing",
          "Regular Blessing services are held in a yearly basis.",
          "Special Blessing services can be requested for specific personal or family occasions.",
          "Documents Needed: None\nNo Service Fees Required.",
          "Documents Needed: None\nOptional fees\n",
        ),
        buildServiceTile(
          "First Holy Communion",
          "Regular First Holy Communion services are held annually for children who have completed their preparation.",
          "Special First Holy Communion services can be arranged for individual families or groups.",
          "Documents Needed: Baptismal Certificate, First Holy Communion Class Completion Certificate\nNo Service Fees Required.",
          "Documents Needed: Baptismal Certificate, First Holy Communion Class Completion Certificate, Special Request Form\nAdditional Fees May Apply.",
        ),
      ],
    );
  }

  Widget buildServiceTile(String title, String regularDescription, String specialDescription, String regularDocuments, String specialDocuments) {
    return DefaultTabController(
      length: 2, // Two tabs: Regular and Special
      child: ExpansionTile(
        title: Text(title),
        children: [
          Container(
            height: 220.0, // Adjust height as needed
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "Regular"),
                    Tab(text: "Special"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(regularDescription),
                            SizedBox(height: 10),
                            Text(regularDocuments),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(specialDescription),
                            SizedBox(height: 10),
                            Text(specialDocuments),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: Scaffold(body: ServiceInformation())));
