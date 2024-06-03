import 'package:flutter/material.dart';
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          height: kToolbarHeight,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0), // Adjust the top padding as needed
              child: Image.asset(
                'holinkLogo.png', // make sure to place the holinkLogo.png file in the assets folder and update pubspec.yaml accordingly
                fit: BoxFit.contain,
                height: 532, // Adjust the height as needed
                width: 532,  // Adjust the width as needed
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
          constraints: BoxConstraints(
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
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'transparent_logo.png', // make sure to place the transparent_logo.png file in the assets folder and update pubspec.yaml accordingly
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white.withOpacity(0.8), // Adding a white overlay for text readability
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
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
                        'HOLINK: Integrated Management for Parishes and Diocese',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black), // Font color added
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'This User Agreement ("Church Service Availment") is entered into by and between [Organization], a [State] corporation ("HOLINK"), and you, the user ("User"), regarding the use of [Company\'s Service/Platform/Website]. By accessing or using the [Company\'s Service/Platform/Website], you agree to be bound by the terms and conditions of this Agreement. If you do not agree to these terms and conditions, you may not access or use the [Company\'s Service/Platform/Website].',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '1. Use of the Service',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1.1 License: Subject to the terms and conditions of this Agreement, Company grants User a limited, non-exclusive, non-transferable, and revocable license to use the [Company\'s Service/Platform/Website] for personal or commercial purposes.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1.2 Restrictions: User agrees not to:',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Use the [Company\'s Service/Platform/Website] for any illegal or unauthorized purpose.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const Text(
                        '• Modify, adapt, or hack the [Company\'s Service/Platform/Website] or modify another website so as to falsely imply that it is associated with the [Company\'s Service/Platform/Website].',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const Text(
                        '• Reproduce, duplicate, copy, sell, resell, or exploit any portion of the [Company\'s Service/Platform/Website] without the express written permission of Company.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '2. User Data and Privacy',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '2.1 Data Collection: Company may collect and use personal information provided by User in accordance with the Company\'s Privacy Policy.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '2.2 Privacy Policy: User agrees to review and comply with the Company\'s Privacy Policy, which can be found on the [Company\'s Service/Platform/Website].',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '3. Intellectual Property Rights',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '3.1 Ownership: All intellectual property rights in the [Company\'s Service/Platform/Website], including but not limited to copyrights, trademarks, and patents, are owned by Company.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '3.2 License Grant: User retains ownership of any intellectual property rights that User holds in the content uploaded or submitted to the [Company\'s Service/Platform/Website], but grants Company a non-exclusive, worldwide, royalty-free license to use, reproduce, and distribute such content.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '4. Limitation of Liability',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '4.1 Disclaimer: The [Company\'s Service/Platform/Website] is provided "as is" and "as available" without any warranties of any kind, either express or implied.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '4.2 Limitation of Liability: Company shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in any way connected with the use of or inability to use the [Company\'s Service/Platform/Website].',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '5. Governing Law',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '5.1 Jurisdiction: This Agreement shall be governed by and construed in accordance with the laws of the State of [State], without regard to its conflict of law principles.',
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
                            style: TextStyle(fontSize: 16, color: Colors.black), // Font color added
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
                                        builder: (context) => const SelectChurchService()),
                                  );
                                }
                              : null,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return _isChecked ? Colors.green : Colors.grey; // Background color when hovered
                                }
                                return _isChecked ? Colors.green : Colors.grey; // Default background color
                              },
                            ),
                            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.white; // Text color when hovered
                                }
                                return Colors.black; // Default text color
                              },
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(
                              const Size(220, 50), // Adjust the width to prevent text wrapping
                            ),
                            alignment: Alignment.center, // Ensure text is centered
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Agree and Proceed',
                            style: TextStyle(fontSize: 18, color: Colors.white), // Text color added
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
