import 'package:flutter/material.dart';

class Approved extends StatelessWidget {
  const Approved({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data for approved services
    List<Map<String, String>> approvedServices = [
      // Add real data once services are approved
    ];

    return _buildServiceList(approvedServices);
  }

  Widget _buildServiceList(List<Map<String, String>> services) {
    return ListView.builder(
      itemCount: services.length,
      itemBuilder: (context, index) {
        var service = services[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: Text(service["title"]!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date Availed: ${service["availedDate"]}"),
                  Text("Scheduled Date: ${service["scheduledDate"]}"),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  // Handle view/edit details
                },
                child: Text("View/Edit Details"),
              ),
            ),
          ),
        );
      },
    );
  }
}
