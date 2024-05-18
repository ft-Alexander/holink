import 'package:flutter/material.dart';
import 'requestsubmitted.dart'; // Import the RequestSubmitted file

class RequirementsPayment extends StatefulWidget {
  const RequirementsPayment({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'REQUIREMENTS & PAYMENT',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Needed Requirements/Documents:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              '(For Optional Payment, Any Amount would be Appreciated)',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Row(
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
                Row(
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
            ],
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestSubmitted(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
