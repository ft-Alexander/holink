import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart'; // Import your localhost instance
import 'Request_Submitted.dart'; // Import the RequestSubmitted file
import 'package:http/http.dart' as http; // Add this import statement

class CancellationInformation extends StatefulWidget {
  final int serviceIndex;

  const CancellationInformation({super.key, required this.serviceIndex});

  @override
  _CancellationInformationState createState() =>
      _CancellationInformationState();
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
    fetchServiceDetails();
  }

  Future<void> fetchServiceDetails() async {
    final url = Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/service/getAllAvailedService.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            serviceDetails = data['services'][widget.serviceIndex];
            isLoading = false;
          });
        } else {
          showError('Failed to fetch service details: ${data['message']}');
        }
      } else {
        showError('Failed to fetch service details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching service details: $error');
      showError('An error occurred while fetching service details: $error');
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
          'http://${localhostInstance.ipServer}/dashboard/myfolder/service/removeAvailedService.php');
      final body = json.encode({
        's_id': serviceDetails!['s_id'].toString(),
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
            SnackBar(content: Text('Service cancelled successfully.')),
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
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
          : Padding(
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
                            Text(
                                "Date Availed: ${serviceDetails?["date_availed"] ?? 'N/A'}"),
                            Text(
                                "Scheduled Date: ${serviceDetails?["scheduled_date"] ?? 'N/A'}"),
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
                      'Note: Cancellation of request is permanent. Any down-payment won’t be refunded as stated in the User Agreement Form. '
                      'Further details will be sent after cancellation of service.',
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                    const Spacer(),
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
                        child: const Text('Submit',
                            style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
