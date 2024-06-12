import 'package:flutter/material.dart';
import 'package:holink/constants/img.path.dart';
import 'package:holink/features/parishioners/service_availment/church_services/churchServices.dart';

class UserAgreement extends StatefulWidget {
  const UserAgreement({super.key});

  @override
  _UserAgreementState createState() => _UserAgreementState();
}

class _UserAgreementState extends State<UserAgreement> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: SizedBox(
          height: kToolbarHeight,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0), // Adjust the top padding as needed
              child: Image.asset(
                holinkWelcome, // make sure to place the holinkLogo.png file in the assets folder and update pubspec.yaml accordingly
                fit: BoxFit.contain,
                height: 532, // Adjust the height as needed
                width: 532, // Adjust the width as needed
              ),
            ),
          ),
        ),
        centerTitle: true,
        actions: [Container(width: 48)], // To center the title
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Container(
            height: 2.0,
            color: Colors.green,
            width: double.infinity,
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1000.0, // Adjust the maxWidth as necessary
          ),
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  transparentlogo, // make sure to place the transparent_logo.png file in the assets folder and update pubspec.yaml accordingly
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white.withOpacity(
                      0.8), // Adding a white overlay for text readability
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'USER AGREEMENT',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Title font color
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Holink: Integrated Management for Parishes and Diocese',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black), // Font color added
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'This User Agreement outlines the terms and conditions of using Holink. Scroll down and click the checkbox below in order to proceed.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '1. Use of the Service',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1.1 Access and Use: Users are granted access to Holink solely for viewing parish and diocesan activities. Users must ensure their usage aligns with the church mission and guidelines.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                                                                                                    
                      const SizedBox(height: 16),
                      const Text(
                        '2. User Data and Privacy',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '2.1 Data Collection: Holink collects personal information necessary for providing its services. This includes names, contact information, and service details.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '2.2 Data Usage: Collected data will be used exclusively for managing church activities and services. Holink will not share personal data with third parties without user consent, except as required by law.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '2.3 User Rights: Users have the right to access, correct, or delete their personal data stored in Holink. Requests can be made through the app or by contacting Holink support.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 16),
                      const Text(
                        '3. Rescheduling and Cancellation of Services',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '3.1 Rescheduling: Users can reschedule services by submitting a rescheduling request through the app at least [specified time period, e.g., 3 days] before the scheduled date. Approval is subject to availability and church policies.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '3.2 Cancellation: Users can cancel services by submitting a cancellation request through the app. Cancellations must be made at least [specified time period, e.g., 3 days] before the scheduled date to avoid any penalties or fees. Late cancellations may incur charges as per church policy.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '4. Amendments',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '4.1 Changes to Agreement: Holink reserves the right to amend this User Agreement at any time. Users will be notified of any significant changes and continued use of the system constitutes acceptance of the new terms.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value ?? false;
                              });
                            },
                          ),
                          const Text(
                            'I agree to the terms and conditions',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black), // Font color added
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isChecked
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SelectChurchService()),
                                  );
                                }
                              : null,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return _isChecked
                                      ? Colors.green
                                      : Colors
                                          .grey; // Background color when hovered
                                }
                                return _isChecked
                                    ? Colors.green
                                    : Colors.grey; // Default background color
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors
                                      .white; // Text color when hovered
                                }
                                return Colors.black; // Default text color
                              },
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(
                              const Size(220,
                                  50), // Adjust the width to prevent text wrapping
                            ),
                            alignment:
                                Alignment.center, // Ensure text is centered
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Agree and Proceed',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white), // Text color added
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
