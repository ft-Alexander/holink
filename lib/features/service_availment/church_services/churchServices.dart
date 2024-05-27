import 'package:flutter/material.dart';
import 'package:holink/features/service_availment/church_services/sacraments/blessing/blessing.dart';

class SelectChurchService extends StatelessWidget {
  const SelectChurchService({super.key});

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
                    'AVAIL CHURCH SERVICE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
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
                  'SELECT CHURCH SERVICE',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              _buildServiceButton(context, 'WEDDING'),
              _buildServiceButton(context, 'BAPTISM'),
              _buildServiceButton(context, 'CONFIRMATION'),
              _buildServiceButton(context, 'MASS FOR THE DEAD'),
              _buildServiceButton(context, 'BLESSING'), // Blessing button
              _buildServiceButton(context, 'FIRST HOLY COMMUNION'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceButton(BuildContext context, String service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          if (service == 'BLESSING') {
            // Navigate to the PublicPrivate page only for Blessing
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const PublicPrivate(service: 'BLESSING')),
            );
          } else {
            // Handle other services if needed
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size.fromHeight(70), // Set height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.black),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              service,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            Row(
              children: const [
                Text(
                  'Avail Service',
                  style: TextStyle(fontSize: 16, color: Color(0xFFd1a65b)),
                ),
                Icon(
                  Icons.arrow_right,
                  color: Color(0xFFd1a65b),
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
