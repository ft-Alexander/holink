import 'package:flutter/material.dart';
import 'package:holink/features/parishioners/service_availment/view/global_state.dart'; // Import the global state
import 'popup_information.dart'; // Import the PopupInformation widget

class PendingServices extends StatelessWidget {
  const PendingServices({super.key});

  Widget _buildServiceList(BuildContext context) {
    List<Map<String, String>> pendingServices =
        globalState.availedServices.where((service) {
      return service["status"] == "pending";
    }).toList();

    if (pendingServices.isEmpty) {
      return const Center(child: Text("No pending services available"));
    }

    return ListView.builder(
      itemCount: pendingServices.length,
      itemBuilder: (context, index) {
        var service = pendingServices[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopupInformation(
                        serviceDetails: service,
                        serviceIndex: index,
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text("View/Edit"),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildServiceList(context),
    );
  }
}
