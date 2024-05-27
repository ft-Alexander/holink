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
                side: const BorderSide(width: 1.0, color:Color(0xFFB37840)), // Border
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
                      fontSize: 12,
                      fontFamily: "DM Sans",
                      fontWeight: FontWeight.bold,
                    ), // Change font color here
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color:  Color(0xFFB37840),
                    size: 15,
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
                side: const BorderSide(width: 1.0, color: Color(0xFFB37840)), // Border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "VIEW/EDIT AVAILED SERVICE\n",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: "DM Sans",
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: "INFORMATION",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: "DM Sans",
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFB37840),
                  size: 15,
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
                side: const BorderSide(width: 1.0, color:Color(0xFFB37840)), // Border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "CANCEL SERVICE",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontFamily: "DM Sans",
                    fontSize: 12,
                    ),
                    
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color:  Color(0xFFB37840),
                    size: 15,
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
