import 'package:flutter/material.dart';
import 'package:holink/features/parishioners/service_availment/church_services/view_edit_service/Edit_Availed_Service_information.dart';
import 'package:holink/features/parishioners/service_availment/church_services/view_edit_service/Reschedule_Availed_Service.dart';
import 'package:intl/intl.dart';

class PopupInformation extends StatelessWidget {
  final Map<String, String> serviceDetails;
  final int serviceIndex;

  const PopupInformation(
      {super.key, required this.serviceDetails, required this.serviceIndex});

  String formatDateTime(String dateTime) {
    // if (dateTime == null) return 'N/A';
    try {
      final DateFormat originalFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final DateFormat desiredFormat = DateFormat('yyyy-MM-dd');
      final DateTime date = originalFormat.parse(dateTime);
      return desiredFormat.format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  String formatTime(String dateTime) {
    // if (dateTime == null) return 'N/A';
    try {
      final DateFormat originalFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final DateFormat timeFormat = DateFormat('hh:mm a');
      final DateTime date = originalFormat.parse(dateTime);
      return timeFormat.format(date);
    } catch (e) {
      return 'N/A';
    }
  }

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
              'Event Name: ${serviceDetails['service'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Scheduled Date: ${formatDateTime(serviceDetails['scheduled_date'] ?? 'N/A')}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Time: ${formatTime(serviceDetails['scheduled_date'] ?? 'N/A')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Parishioner's Details:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Selected Type: ${serviceDetails['selected_type'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Full Name: ${serviceDetails['fullName'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'SKK NO: ${serviceDetails['skk_number'] ?? 'N/A'}',
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
              'Contact Number: ${serviceDetails['contact_number'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (!isApproved) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAvailedServiceInformation(
                              serviceIndex: serviceIndex),
                        ),
                      );
                      if (result == 'updated') {
                        Navigator.pop(context, 'updated');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(120, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Edit Information',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RescheduleAvailedService(
                              serviceIndex: serviceIndex),
                        ),
                      );
                      if (result == 'updated') {
                        Navigator.pop(context, 'updated');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(120, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Reschedule',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
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
