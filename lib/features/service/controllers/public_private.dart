import 'package:flutter/material.dart';
import 'blessingform.dart'; // Import the BlessingForm file

class PublicPrivate extends StatelessWidget {
  final String service;

  const PublicPrivate({required this.service, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'CHOOSE SERVICE TYPE',
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
          children: [
            const SizedBox(height: 16),
            _buildServiceTypeButton(
              context,
              'REGULAR (Public)',
              isAvailable: false,
            ),
            const SizedBox(height: 16),
            _buildServiceTypeButton(
              context,
              'SPECIAL (Private)',
              isAvailable: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTypeButton(BuildContext context, String title,
      {required bool isAvailable}) {
    return ElevatedButton(
      onPressed: isAvailable
          ? () {
              if (service == 'BLESSING') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BlessingForm()),
                );
              } else {
                // Handle other services if needed
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isAvailable ? Colors.green : Colors.grey,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(70), // Set height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          if (isAvailable)
            Row(
              children: const [
                Text(
                  'Avail Special Service',
                  style: TextStyle(fontSize: 16),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 24,
                ),
              ],
            )
          else
            const Text(
              'Not Available',
              style: TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }
}
