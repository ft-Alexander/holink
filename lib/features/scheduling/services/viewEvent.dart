import 'package:flutter/material.dart';
import 'package:holink/features/scheduling/model/getEvent_pub_pri.dart';
import 'package:intl/intl.dart'; // Replace with the correct path to your Event model

class ViewEventScreen extends StatelessWidget {
  final getEvent event;

  const ViewEventScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40), // Add space at the top
            Center(
              child: Text(
                event.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow(
                'Date:', DateFormat('MMMM d, y').format(event.date)),
            _buildDetailRow('Time:', DateFormat('h:mm a').format(event.date)),
            _buildDetailRow('Event Type:', event.event_type),
            _buildDetailRow('Sacraments:', event.sacraments),

            _buildDetailRow('Location:', event.address),

            _buildDetailRow('Priest:', event.priest),
            _buildDetailRow('Lectors:', event.lectors),
            _buildDetailRow('Sacristan:', event.sacristan),

            _buildDetailRow('Details:', event.details),

            Spacer(), // Push the close button to the bottom
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 18, fontFamily: 'DM Sans'),
                ),
                child: Text('Close'),
              ),
            ),
            SizedBox(height: 20), // Add space below the button
          ],
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
