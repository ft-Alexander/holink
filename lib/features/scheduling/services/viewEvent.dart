import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:holink/features/scheduling/model/getEvent_pub_reg.dart';

class ViewEventScreen extends StatelessWidget {
  final getEvent event;

  const ViewEventScreen({super.key, required this.event});

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  event.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
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
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB37840), // Button color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18, fontFamily: 'DM Sans'),
                  ),
                  child: Text('Close'),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
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
