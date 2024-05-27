import 'package:flutter/material.dart';
import 'package:holink/features/service_availment/church_services/userAgreement.dart'; // Import the User Agreement widget
import 'package:holink/features/service_availment/church_services/view_edit_service/ViewEditInformation.dart'; // Import the ViewEditInformation widget
import 'package:holink/features/service_availment/church_services/cancel_service/Cancel_Availed_Service.dart'; // Import the CancelAvailedService widget

class BottomButtons extends StatelessWidget {
  const BottomButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the UserAgreement page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserAgreement()),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(400, 60), // Adjust the width and height as needed
                alignment: Alignment.centerLeft, // Align text to the left
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding
                side: const BorderSide(width: 1.0, color: Colors.black), // Border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textStyle: const TextStyle(color: Color.fromARGB(255, 16, 16, 16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "AVAIL CHURCH SERVICE",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ), // Change font color here
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                    size: 40,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the ViewEditInformation page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewEditInformation()),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(400, 60), // Adjust the width and height as needed
                alignment: Alignment.centerLeft, // Align text to the left
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding
                side: const BorderSide(width: 1.0, color: Colors.black), // Border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "VIEW/EDIT AVAILED SERVICE INFORMATION",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                    size: 40,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the CancelAvailedService page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CancelAvailedService()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                fixedSize: const Size(400, 60), // Adjust the width and height as needed
                alignment: Alignment.centerLeft, // Align text to the left
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding
                side: const BorderSide(width: 1.0, color: Colors.black), // Border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "CANCEL SERVICE",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                    size: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
