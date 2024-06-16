import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart'; // Import localhost for database connection
import 'Cancellation_information.dart'; // Import the CancellationInformation widget
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CancelAvailedService extends StatefulWidget {
  const CancelAvailedService({super.key});

  @override
  _CancelAvailedServiceState createState() => _CancelAvailedServiceState();
}

class _CancelAvailedServiceState extends State<CancelAvailedService> {
  List<Map<String, String>> availedServices = [];
  bool isLoading = true;
  localhost localhostInstance = localhost();

  @override
  void initState() {
    super.initState();
    fetchAvailedServices();
  }

  Future<void> fetchAvailedServices() async {
    final url = Uri.parse('http://${localhostInstance.ipServer}/dashboard/myfolder/service/getAvailedServiceBlessing.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            availedServices = List<Map<String, String>>.from(data['services']
                .map((service) => Map<String, String>.from(service)));
            isLoading = false;
            print('Fetched availed services: $availedServices'); // Debug print statement
          });
        } else {
          showError(data['message']);
        }
      } else {
        showError('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error'); // Debug print statement
      showError('An error occurred: $error');
    }
  }

  void showError(String message) {
    print('Error: $message'); // Debug print statement
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {
      isLoading = false;
    });
  }

  String formatDate(String dateTime) {
    try {
      final DateFormat originalFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final DateFormat targetFormat = DateFormat('MM/dd/yyyy');
      final DateTime parsedDateTime = originalFormat.parse(dateTime);
      return targetFormat.format(parsedDateTime);
    } catch (e) {
      return dateTime;
    }
  }

  String formatDateTime(String dateTime) {
    try {
      final DateFormat originalFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final DateFormat targetFormat = DateFormat('MM/dd/yyyy hh:mm a');
      final DateTime parsedDateTime = originalFormat.parse(dateTime);
      return targetFormat.format(parsedDateTime);
    } catch (e) {
      return dateTime;
    }
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
                    'CANCEL SERVICE',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFd1a65b), // Button background color
                        minimumSize: const Size.fromHeight(50), // Set height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Choose Availed Service to Cancel',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: availedServices.length,
                      itemBuilder: (context, index) {
                        var service = availedServices[index];
                        String formattedDateTime =
                            formatDateTime(service["event_date"] ?? 'N/A');
                        String formattedAvailedDate =
                            formatDate(service["availed_date"] ?? 'N/A');

                        print('Service: ${service["service"]}'); // Debug print statement
                        print('Date Availed: ${service["availed_date"]}');
                        print('Scheduled Date: $formattedDateTime');

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            child: ListTile(
                              title: Text('${service["service"] ?? 'N/A'} (ID#: 000${service["id"] ?? 'N/A'})'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Date Availed: $formattedAvailedDate"),
                                  Text("Scheduled Date: $formattedDateTime"),
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CancellationInformation(
                                        serviceIndex: index,
                                        serviceDetails: service,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
