import 'package:flutter/material.dart';
import 'package:holink/features/service_availment/view/global_state.dart'; // Import the global state
import 'popup_information.dart'; // Import the PopupInformation widget

class ApprovedServices extends StatefulWidget {
  const ApprovedServices({super.key});

  @override
  _ApprovedServicesState createState() => _ApprovedServicesState();
}

class _ApprovedServicesState extends State<ApprovedServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 2.0,
            color: Colors.green,
          ),
        ),
        title: const Text(
          'Approved Services',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: globalState.availedServices.length,
          itemBuilder: (context, index) {
            var service = globalState.availedServices[index];
            if (service["status"] != "approved") return Container(); // Skip non-approved services

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                child: ListTile(
                  title: Text(service["title"]!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date Availed: ${service["availedDate"]}"),
                      Text("Scheduled Date: ${service["scheduledDate"]}"),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PopupInformation(
                            serviceDetails: service,
                            serviceIndex: index,
                          );
                        },
                      );
                    },
                    child: const Text("View"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



