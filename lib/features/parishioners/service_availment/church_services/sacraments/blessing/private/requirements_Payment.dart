import 'package:flutter/material.dart';
import 'requestsubmitted.dart'; // Import the RequestSubmitted file
import 'package:holink/features/parishioners/service_availment/view/global_state.dart'; // Import the global state

class RequirementsPayment extends StatefulWidget {
  final Map<String, String> serviceDetails;

  const RequirementsPayment({super.key, required this.serviceDetails});

  @override
  _RequirementsPaymentState createState() => _RequirementsPaymentState();
}

class _RequirementsPaymentState extends State<RequirementsPayment> {
  bool onsiteSelected = false;
  bool gcashSelected = false;
  bool skipSelected = false;
  String uploadedFile = '';

  void _selectPaymentOption(bool onsite, bool gcash, bool skip) {
    setState(() {
      onsiteSelected = onsite;
      gcashSelected = gcash;
      skipSelected = skip;
    });
  }

  Future<void> _uploadReceipt() async {
    // Implement file upload functionality here
    // For now, we'll just simulate an uploaded file name
    setState(() {
      uploadedFile = 'IMG_27381218_8273987.png';
    });
  }

  void _submitService() {
    final service = widget.serviceDetails;
    globalState.availedServices.add(service);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const RequestSubmitted()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'REQUIRMENTS AND PAYMENTS',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Needed Requirements/Documents:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
            
            ),
            const SizedBox(height: 8),
            const Text(
              'No Requirements/Documents needed.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Necessity: Optional',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              '(For Optional Payment, Onsite: Users can give either monetary or offeratory, Any Amount would be Appreciated)',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: onsiteSelected,
                  onChanged: (bool? value) {
                    _selectPaymentOption(value!, false, false);
                  },
                ),
                const Text('Onsite'),
                Checkbox(
                  value: gcashSelected,
                  onChanged: (bool? value) {
                    _selectPaymentOption(false, value!, false);
                  },
                ),
                const Text('Gcash'),
                Checkbox(
                  value: skipSelected,
                  onChanged: (bool? value) {
                    _selectPaymentOption(false, false, value!);
                  },
                ),
                const Text('Skip'),
              ],
            ),
          ),

            if (gcashSelected) ...[
              const SizedBox(height: 8),
              const Text(
                'Gcash #: 639293137745 (ED** JA**S A.)',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please Upload Receipt for Verification.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _uploadReceipt,
                child: const Text('Upload Receipt'),
              ),
              const SizedBox(height: 8),
              if (uploadedFile.isNotEmpty)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        uploadedFile,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            uploadedFile = '';
                          });
                        },
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                ),

            ],
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: _submitService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
