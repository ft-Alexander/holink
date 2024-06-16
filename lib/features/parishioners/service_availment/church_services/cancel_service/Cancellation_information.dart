import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart'; // Import your localhost instance
import 'Request_Submitted.dart'; // Import the RequestSubmitted file
import 'package:http/http.dart' as http; // Add this import statement
import 'package:intl/intl.dart'; // Add this import statement

class CancellationInformation extends StatefulWidget {
  final int serviceIndex;
  final Map<String, String> serviceDetails; // Add serviceDetails parameter

  const CancellationInformation({super.key, required this.serviceIndex, required this.serviceDetails}); // Update the constructor

  @override
  _CancellationInformationState createState() => _CancellationInformationState();
}

class _CancellationInformationState extends State<CancellationInformation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = true;
  Map<String, dynamic>? serviceDetails;
  localhost localhostInstance = localhost(); // Initialize localhost instance

  @override
  void initState() {
    super.initState();
    serviceDetails = widget.serviceDetails; // Initialize with passed service details
    setState(() {
      isLoading = false; // Set isLoading to false since details are already provided
    });

    // Print service details for debugging
    print('Service Details:');
    serviceDetails?.forEach((key, value) {
      print('$key: $value');
    });
  }

  String _formatDate(String? date) {
    if (date == null || date == 'N/A') {
      return 'N/A';
    }
    try {
      final DateFormat originalFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final DateFormat desiredFormat = DateFormat('MM/dd/yyyy');
      final DateTime dateTime = originalFormat.parse(date);
      return desiredFormat.format(dateTime);
    } catch (e) {
      print('Error formatting date: $e'); // Debug print statement
      return 'N/A';
    }
  }

  String _formatTime(String? date) {
    if (date == null || date == 'N/A') {
      return 'N/A';
    }
    try {
      final DateFormat originalFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final DateFormat desiredFormat = DateFormat('hh:mm a');
      final DateTime dateTime = originalFormat.parse(date);
      return desiredFormat.format(dateTime);
    } catch (e) {
      print('Error formatting time: $e'); // Debug print statement
      return 'N/A';
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _submitCancellation() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
          'http://${localhostInstance.ipServer}/dashboard/myfolder/service/removeAvailedServiceBlessing.php');
      final body = json.encode({
        'id': serviceDetails!['id'].toString(),
        'description': _descriptionController.text,
      });

      try {
        print('Sending request to $url with body: $body');
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        final data = json.decode(response.body);
        print('Parsed data: $data');
        if (data['success']) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RequestSubmitted()),
            (Route<dynamic> route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Service cancelled successfully.')),
          );
        } else {
          showError('Failed to cancel service: ${data['message']}');
        }
      } catch (error) {
        print('Error cancelling service: $error');
        showError('An error occurred while cancelling service: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availedDate = serviceDetails?["availed_date"];
    final scheduledDate = serviceDetails?["event_date"];
    final formattedAvailedDate = _formatDate(availedDate);
    final formattedScheduledDate = _formatDate(scheduledDate);
    final formattedScheduledTime = _formatTime(scheduledDate);

    print('Availed Date: $availedDate'); // Debug print statement
    print('Scheduled Date: $scheduledDate'); // Debug print statement
    print('Formatted Availed Date: $formattedAvailedDate'); // Debug print statement
    print('Formatted Scheduled Date: $formattedScheduledDate'); // Debug print statement
    print('Formatted Scheduled Time: $formattedScheduledTime'); // Debug print statement

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
                    'CANCEL AVAILED SERVICE',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(serviceDetails?["service"] ?? 'N/A'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date Availed: $formattedAvailedDate"),
                            Text("Scheduled Date: $formattedScheduledDate"),
                            Text("Time: $formattedScheduledTime"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please enter information on why you decided to cancel the availed service, '
                      'we would appreciate knowing why it has come to this decision. Thank you for your cooperation.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Enter description:',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Note: Cancellation of request is permanent. Any down-payment might be refunded as stated in the User Agreement Form. '
                      'Further details will be sent after cancellation of service.',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: _submitCancellation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Submit', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
