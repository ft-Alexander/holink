import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'requirements_Payment.dart'; // Import the RequirementsPayment file
import '../../../../model/service_model.dart'; // Import the ServiceInformation model
import 'package:holink/dbConnection/localhost.dart'; // Import the localhost file

class ReviewInformation extends StatelessWidget {
  final ServiceInformation serviceInformation;
  localhost localhostInstance = localhost();

  ReviewInformation({
    required this.serviceInformation,
    super.key,
  });

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return "$hour:${date.minute.toString().padLeft(2, '0')} $period";
  }

  Future<void> _saveEvent(BuildContext context) async {
    try {
      // Convert DateTime object to a string format suitable for the database
      final DateFormat outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final String formattedDateTime = outputFormat.format(serviceInformation.scheduled_date);

      final url = Uri.parse('http://${localhostInstance.ipServer}/dashboard/myfolder/service/saveBlessingEvent.php');
      print('Saving to database: $url'); // Debug print statement

      // Print the serviceInformation values to the console
      print('availed_date: ${serviceInformation.availed_date.toIso8601String()}');
      print('special_event: ${serviceInformation.special_event}');
      print('scheduled_date: ${serviceInformation.scheduled_date}');
      print('service: ${serviceInformation.service}');
      print('event_type: ${serviceInformation.event_type}');
      print('fullName: ${serviceInformation.fullName}');
      print('skk_number: ${serviceInformation.skk_number}');
      print('address: ${serviceInformation.address}');
      print('landmark: ${serviceInformation.landmark}');
      print('contact_number: ${serviceInformation.contact_number}');
      print('select_type: ${serviceInformation.select_type}');

      // Print the request body
      final requestBody = {
        'availed_date': serviceInformation.availed_date.toIso8601String(),
        'special_event': serviceInformation.special_event.toString(), // Converted int to string
        'scheduled_date': serviceInformation.scheduled_date.toIso8601String(),
        'service': serviceInformation.service,
        'serviceType': serviceInformation.event_type,
        'fullName': serviceInformation.fullName,
        'skkNumber': serviceInformation.skk_number,
        'address': serviceInformation.address,
        'landmark': serviceInformation.landmark,
        'contactNumber': serviceInformation.contact_number,
        'selectedType': serviceInformation.select_type,
      };
      print('Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        url,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['success']) {
          // Navigate to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequirementsPayment(
                serviceDetails: {
                  "title": serviceInformation.service,
                  "availedDate": serviceInformation.availed_date.toString(),
                  "scheduledDate": serviceInformation.scheduled_date.toString(),
                  "time": _formatTime(serviceInformation.scheduled_date),
                  "Service type": serviceInformation.event_type,
                  "fullName": serviceInformation.fullName,
                  "skkNumber": serviceInformation.skk_number,
                  "address": serviceInformation.address,
                  "landmark": serviceInformation.landmark,
                  "contactNumber": serviceInformation.contact_number,
                  "selectedType": serviceInformation.select_type,
                },
              ),
            ),
          );
        } else {
          print('Failed to save data: ${responseBody['message']}');
          _showErrorMessage(context, 'Failed to save data: ${responseBody['message']}');
        }
      } else {
        print('Failed to save data: ${response.statusCode}');
        _showErrorMessage(context, 'Failed to save data: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
      _showErrorMessage(context, 'An error occurred: $error');
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'REVIEW INFORMATION',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 118, 164, 38),
                    ),
                  ),
                ),
              ),
              Container(
                height: 2.0,
                color: Colors.green,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildReviewRow('Church Service:', serviceInformation.service),
            const SizedBox(height: 16),
            _buildReviewRow('Service Type:', serviceInformation.event_type),
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
                  _buildInfoText('Selected Type: ${serviceInformation.select_type}'),
                  _buildInfoText('Full Name: ${serviceInformation.fullName}'),
                  _buildInfoText('SKK NO: ${serviceInformation.skk_number}'),
                  _buildInfoText('Address: ${serviceInformation.address}'),
                  _buildInfoText('Nearby Landmark: ${serviceInformation.landmark}'),
                  _buildInfoText('Contact Number: ${serviceInformation.contact_number}'),
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
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  _saveEvent(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 18, color: Colors.white)),
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
