import 'package:flutter/material.dart';
import 'requirements_Payment.dart'; // Import the RequirementsPayment file

class ReviewInformation extends StatelessWidget {
  final String service;
  final String serviceType;
  final String fullName;
  final String skkNumber;
  final String address;
  final String landmark;
  final String contactNumber;
  final String date;
  final String time;

  const ReviewInformation({
    required this.service,
    required this.serviceType,
    required this.fullName,
    required this.skkNumber,
    required this.address,
    required this.landmark,
    required this.contactNumber,
    required this.date,
    required this.time,
    Key? key,
  }) : super(key: key);

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
            _buildReviewRow('Church Service:', service),
            const SizedBox(height: 16),
            _buildReviewRow('Service Type:', serviceType),
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
                  _buildInfoText('Full Name: $fullName'),
                  _buildInfoText('SKK NO: $skkNumber'),
                  _buildInfoText('Address: $address'),
                  _buildInfoText('Nearby Landmark: $landmark'),
                  _buildInfoText('Contact Number: $contactNumber'),
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
                _buildScheduleInfo('Month/Day/Year', date),
                _buildScheduleInfo('Time', time),
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
                          "title": service,
                          "availedDate": DateTime.now().toString(), // Current date as availed date
                          "scheduledDate": date,
                          "time": time,
                          "fullName": fullName,
                          "skkNumber": skkNumber,
                          "address": address,
                          "landmark": landmark,
                          "contactNumber": contactNumber,
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

