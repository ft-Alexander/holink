import 'package:flutter/material.dart';
import 'package:holink/features/parishioners/service_availment/view/service.dart'; // Import the Service file

class RequestSubmitted extends StatelessWidget {
  const RequestSubmitted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Avail Church Service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 32),
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 200,
            ),
            const SizedBox(height: 32),
            const Text(
              'Request Successfully Submitted!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'This is to confirm that we have successfully received your request description for [Blessing]. Our team is currently reviewing your request, and we will get back to you shortly with further details.\n\nShould you have any questions or need immediate assistance, please do not hesitate to contact us at [+63XXXXXXXXXX].',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Service()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Return', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
