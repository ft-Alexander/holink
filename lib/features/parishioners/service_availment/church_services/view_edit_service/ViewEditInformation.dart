import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart';
import 'package:http/http.dart' as http;
import 'popup_information.dart'; // Import the PopupInformation widget
import 'package:intl/intl.dart';

class ViewEditInformation extends StatefulWidget {
  const ViewEditInformation({super.key});

  @override
  _ViewEditInformationState createState() => _ViewEditInformationState();
}

class _ViewEditInformationState extends State<ViewEditInformation> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, String>> availedServices = [];
  bool isLoading = true;
  localhost localhostInstance = localhost();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Three tabs now
    fetchAvailedServices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String date) {
    try {
      final DateFormat originalFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final DateFormat desiredFormat = DateFormat('MM/dd/yyyy');
      final DateTime dateTime = originalFormat.parse(date);
      return desiredFormat.format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatTime(String date) {
    try {
      final DateFormat originalFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final DateFormat desiredFormat = DateFormat('hh:mm a');
      final DateTime dateTime = originalFormat.parse(date);
      return desiredFormat.format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  Future<void> fetchAvailedServices() async {
    final url = Uri.parse('http://${localhostInstance.ipServer}/dashboard/myfolder/service/getAvailedServiceBlessing.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            availedServices = List<Map<String, String>>.from(data['services']
                .map((service) => Map<String, String>.from(service)));
            isLoading = false;
          });
        } else {
          showError(data['message']);
        }
      } else {
        showError('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error'); // Debug print statement
      showError('An error occurred: $error');
    }
  }

  void showError(String message) {
    print('Error: $message'); // Debug print statement
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildServiceList() {
    return ListView.builder(
      itemCount: availedServices.length,
      itemBuilder: (context, index) {
        var service = availedServices[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            child: ListTile(
              title: Text('${service["service"] ?? 'N/A'} (ID#: 000${service["id"] ?? 'N/A'})'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date Availed: ${_formatDate(service["availed_date"] ?? 'N/A')}"),
                  Text("Scheduled Date: ${_formatDate(service["event_date"] ?? 'N/A')} ${_formatTime(service["event_date"] ?? 'N/A')}"),
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
                child: const Text("View/Edit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          labelColor: Colors.green,
          unselectedLabelColor: const Color.fromARGB(255, 3, 3, 3),
          tabs: const [
            Tab(text: 'Availed Service'),
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
          ],
        ),
        title: const Text(
          'View/Edit/Reschedule Availed Service',
          style: TextStyle(
              fontSize: 15, color: Colors.green, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildServiceList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      _buildServiceList(), // Placeholder for 'Pending' services
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      _buildServiceList(), // Placeholder for 'Approved' services
                ),
              ],
            ),
    );
  }
}
