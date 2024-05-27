import 'package:flutter/material.dart';
import 'package:holink/features/service_availment/church_services/view_edit_service/Reschedule_Availed_Service.dart';
import 'Edit_Availed_Service_information.dart'; // Import the EditAvailedServiceInformation widget

class PopupInformation extends StatelessWidget {
  final Map<String, String> serviceDetails;
  final int serviceIndex;

  const PopupInformation({super.key, required this.serviceDetails, required this.serviceIndex});

  @override
  Widget build(BuildContext context) {
    final bool isApproved = serviceDetails['status'] == 'approved';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Name: ${serviceDetails['title'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Scheduled Date: ${serviceDetails['scheduledDate'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Time: ${serviceDetails['time'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Parishioner's Details:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Selected Type: ${serviceDetails['selectedType'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Full Name: ${serviceDetails['fullName'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'SKK NO: ${serviceDetails['skkNumber'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Address: ${serviceDetails['address'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Nearby Landmark: ${serviceDetails['landmark'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Contact Number: ${serviceDetails['contactNumber'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (!isApproved) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAvailedServiceInformation(serviceIndex: serviceIndex),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(120, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Edit Information', style: TextStyle(fontSize: 14)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RescheduleAvailedService(serviceIndex: serviceIndex),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(120, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Reschedule', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
