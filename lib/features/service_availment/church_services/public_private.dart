import 'package:flutter/material.dart';
import 'package:holink/features/service_availment/church_services/sacraments/blessing/private/blessingform.dart';
import 'package:holink/features/service_availment/church_services/sacraments/blessing/public/public_event_page.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildServiceTypeButton(
                context,
                'REGULAR (Public)',
                isAvailable: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PublicEventsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildServiceTypeButton(
                context,
                'SPECIAL (Private)',
                isAvailable: true,
                onTap: () {
                  if (service == 'BLESSING') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BlessingForm(),
                      ),
                    );
                  } else {
                    // Handle other services if needed
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceTypeButton(BuildContext context, String title,
      {required bool isAvailable, required Function onTap}) {
    return ElevatedButton(
      onPressed: isAvailable ? () => onTap() : null,
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
