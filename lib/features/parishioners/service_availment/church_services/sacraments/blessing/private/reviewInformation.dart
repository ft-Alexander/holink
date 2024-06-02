import 'package:flutter/material.dart';
import 'requirements_Payment.dart'; // Import the RequirementsPayment file
import '../../../../model/service_model.dart'; // Import the ServiceInformation model

class ReviewInformation extends StatelessWidget {
  final ServiceInformation serviceInformation;

  const ReviewInformation({
    required this.serviceInformation,
    Key? key,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return "${hour}:${date.minute.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'REVIEW INFORMATION',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 2.0,
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildReviewRow('Church Service:', serviceInformation.service),
            const SizedBox(height: 16),
            _buildReviewRow('Service Type:', serviceInformation.serviceType),
            const SizedBox(height: 16),
            const Text(
              'Parishioner Detail\'s:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoText('Selected Type: ${serviceInformation.selectedType}'),
                  _buildInfoText('Full Name: ${serviceInformation.fullName}'),
                  _buildInfoText('SKK NO: ${serviceInformation.skkNumber}'),
                  _buildInfoText('Address: ${serviceInformation.address}'),
                  _buildInfoText('Nearby Landmark: ${serviceInformation.landmark}'),
                  _buildInfoText('Contact Number: ${serviceInformation.contactNumber}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Schedule:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildScheduleInfo('Month/Day/Year', _formatDate(serviceInformation.scheduled_date)),
                _buildScheduleInfo('Time', _formatTime(serviceInformation.scheduled_date)),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequirementsPayment(
                        serviceDetails: {
                          "title": serviceInformation.service,
                          "availedDate": serviceInformation.date_availed.toString(),
                          "scheduledDate": serviceInformation.scheduled_date.toString(),
                          "time": _formatTime(serviceInformation.scheduled_date),
                          "Service type": serviceInformation.serviceType,
                          "fullName": serviceInformation.fullName,
                          "skkNumber": serviceInformation.skkNumber,
                          "address": serviceInformation.address,
                          "landmark": serviceInformation.landmark,
                          "contactNumber": serviceInformation.contactNumber,
                          "selectedType": serviceInformation.selectedType,
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText(String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        info,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildScheduleInfo(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
