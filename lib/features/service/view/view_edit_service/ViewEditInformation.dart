import 'package:flutter/material.dart';
import 'package:holink/features/service/view/global_state.dart'; // Import the global state
import 'popup_information.dart'; // Import the PopupInformation widget

class ViewEditInformation extends StatefulWidget {
  const ViewEditInformation({super.key});

  @override
  _ViewEditInformationState createState() => _ViewEditInformationState();
}

class _ViewEditInformationState extends State<ViewEditInformation> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildServiceList() {
    return ListView.builder(
      itemCount: globalState.availedServices.length,
      itemBuilder: (context, index) {
        var service = globalState.availedServices[index];

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
                child: Text("View/Edit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          labelColor: Colors.green,
          unselectedLabelColor: const Color.fromARGB(255, 3, 3, 3),
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
          ],
        ),
        title: const Text(
          'View/Edit Availed Service Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildServiceList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildServiceList(),
          ),
        ],
      ),
    );
  }
}
