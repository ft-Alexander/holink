import 'package:flutter/material.dart';
import 'package:holink/features/service/view/global_state.dart'; // Import the global state
import 'request_submitted.dart'; // Import the RequestSubmitted file

class CancellationInformation extends StatefulWidget {
  final int serviceIndex;

  const CancellationInformation({super.key, required this.serviceIndex});

  @override
  _CancellationInformationState createState() => _CancellationInformationState();
}

class _CancellationInformationState extends State<CancellationInformation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  void _submitCancellation() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (globalState.availedServices.length > widget.serviceIndex) {
          globalState.availedServices.removeAt(widget.serviceIndex);
        }
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RequestSubmitted()),
        (Route<dynamic> route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service cancelled successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (globalState.availedServices.length <= widget.serviceIndex) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: Container(
              height: 2.0,
              color: Colors.green,
            ),
          ),
          title: const Text(
            'Cancel Service',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: Center(
          child: Text('No service found to cancel.'),
        ),
      );
    }

    var service = globalState.availedServices[widget.serviceIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 2.0,
            color: Colors.green,
          ),
        ),
        title: const Text(
          'Cancel Service',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  title: Text(service["title"]!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date Availed: ${service["availedDate"]}"),
                      Text("Scheduled Date: ${service["scheduledDate"]}"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please enter information on why you decided to cancel the availed service, '
                'we would appreciate knowing why it has come to this decision. Thank you for your cooperation.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Enter description:',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Note: Cancellation of request is permanent. Any down-payment won’t be refunded as stated in the User Agreement Form. '
                'Further details will be sent after cancellation of service.',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: _submitCancellation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
