import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/parish/scheduling/model/getEvent_pri.dart';
import 'package:holink/features/parish/scheduling/model/getEvent_pub_reg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ViewPrivateScreen extends StatefulWidget {
  final getEvent event;

  const ViewPrivateScreen({super.key, required this.event});

  @override
  _ViewPrivateScreenState createState() => _ViewPrivateScreenState();
}

class _ViewPrivateScreenState extends State<ViewPrivateScreen> {
  late Future<PrivateEvent> privateEvent;
  localhost localhostInstance = localhost();

  @override
  void initState() {
    super.initState();
    privateEvent = fetchPrivateEvent(widget.event.s_id);
  }

  Future<PrivateEvent> fetchPrivateEvent(int s_id) async {
    final url =
        'http://${localhostInstance.ipServer}/dashboard/myfolder/service/getAvailedService.php?s_id=$s_id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success']) {
        return PrivateEvent.fromJson(jsonResponse['services'][0]);
      } else {
        throw Exception(
            'Failed to load private event: ${jsonResponse['message']}');
      }
    } else {
      throw Exception(
          'Failed to load private event: HTTP ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Color(0xFFB37840), width: 2),
      ),
      child: Container(
        width:
            MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
        padding: EdgeInsets.fromLTRB(16, 16, 16, 25),
        child: FutureBuilder<PrivateEvent>(
          future: privateEvent,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data found'));
            } else {
              final event = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Full Name:', event.fullName),
                    _buildDetailRow('SKK Number:', event.skkNumber),
                    _buildDetailRow('Address:', event.address),
                    _buildDetailRow('Landmark:', event.landmark),
                    _buildDetailRow('Contact Number:', event.contactNumber),
                    _buildDetailRow('Service:', event.service),
                    _buildDetailRow('Service Type:', event.serviceType),
                    _buildDetailRow('Selected Type:', event.selectedType),
                    _buildDetailRow('Date Availed:',
                        DateFormat.yMMMd().format(event.date_availed)),
                    _buildDetailRow('Scheduled Date:',
                        DateFormat.yMMMd().format(event.scheduled_date)),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB37840), // Button color
                          foregroundColor: Colors.white, // Text color
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          textStyle:
                              TextStyle(fontSize: 18, fontFamily: 'DM Sans'),
                        ),
                        child: Text('Close'),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'DM Sans',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
                fontFamily: 'DM Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
