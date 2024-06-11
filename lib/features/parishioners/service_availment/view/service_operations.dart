import 'package:flutter/material.dart';
import 'package:holink/features/parishioners/service_availment/church_services/userAgreement.dart';
import 'package:holink/features/parishioners/service_availment/church_services/view_edit_service/ViewEditInformation.dart';
import 'package:holink/features/parishioners/service_availment/church_services/cancel_service/Cancel_Availed_Service.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserAgreement(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 50),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                side: const BorderSide(width: 1.0, color: Color(0xFFB37840)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textStyle:
                    const TextStyle(color: Color.fromARGB(255, 16, 16, 16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "AVAIL CHURCH SERVICE",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 10,
                      fontFamily: "DM Sans",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewEditInformation(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 50),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                side: const BorderSide(width: 1.0, color: Color(0xFFB37840)),
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
                            fontSize: 10,
                          ),
                        ),
                        TextSpan(
                          text: "INFORMATION",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "DM Sans",
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CancelAvailedService(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                fixedSize: const Size(250, 50),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                side: const BorderSide(width: 1.0, color: Color(0xFFB37840)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "CANCEL SERVICE",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontFamily: "DM Sans",
                      fontSize: 10,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFB37840),
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
