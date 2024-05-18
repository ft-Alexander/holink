import 'package:flutter/material.dart';

class Pending extends StatelessWidget {
  const Pending({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data for pending services
    List<Map<String, String>> pendingServices = [
      {
        "title": "Wedding",
        "availedDate": "February 14, 2024, 10:00 AM",
        "scheduledDate": "February 14, 2024",
      },
      {
        "title": "Blessing",
        "availedDate": "February 14, 2024, 10:00 AM",
        "scheduledDate": "February 25, 2024",
      },
    ];

    return _buildServiceList(pendingServices);
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
