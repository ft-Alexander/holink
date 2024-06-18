import 'package:flutter/material.dart';
import 'package:holink/features/parishioners/service_availment/church_services/sacraments/blessing/private/blessingform.dart';

class PublicPrivate extends StatelessWidget {
  final String service;

  const PublicPrivate({required this.service, super.key});

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
                    'CHOOSE SERVICE TYPE',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildServiceTypeButton(
                context,
                'REGULAR(Public)',
                isAvailable: true,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildServiceTypeButton(
                context,
                'SPECIAL(Private)',
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
        backgroundColor: Colors.white,
        foregroundColor: isAvailable ? const Color(0xFFd1a65b) : Colors.grey,
        minimumSize: const Size.fromHeight(70), // Set height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
              color: isAvailable
                  ? const Color(0xFFd1a65b)
                  : Colors.grey), // Add border color
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isAvailable
                  ? Colors.black
                  : Colors.grey, // Font color for regular and private
            ),
          ),
          if (isAvailable)
            const Row(
              children: [
                Text(
                  'Avail Service',
                  style: TextStyle(fontSize: 16, color: Color(0xFFd1a65b)),
                ),
                Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 20,
                  color: Color(0xFFd1a65b),
                ),
              ],
            )
          else
            const Text(
              'Not Available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
