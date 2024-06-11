import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/parish/scheduling/model/getEvent_pub_reg.dart';
import 'package:holink/features/parishioners/service_availment/church_services/sacraments/blessing/public/join_event.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublicEventsPage extends StatefulWidget {
  const PublicEventsPage({super.key});

  @override
  _PublicEventsPageState createState() => _PublicEventsPageState();
}

class _PublicEventsPageState extends State<PublicEventsPage> {
  List<getEvent> publicEvents = [];
  localhost localhostInstance = localhost();

  @override
  void initState() {
    super.initState();
    fetchAndSetEvents();
  }

  Future<void> fetchAndSetEvents() async {
    try {
      final events = await fetchEvents();
      setState(() {
        publicEvents = events.where((event) {
          final now = DateTime.now();
          return event.event_type == "Public" &&
              event.sacraments == "Blessing" &&
              event.archive_status != "archive" &&
              event.date.isAfter(now);
        }).toList();
      });
    } catch (error) {
      print('Error fetching events: $error');
    }
  }

  Future<List<getEvent>> fetchEvents() async {
    final response = await http.get(Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/getEvents.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Events data retrieved successfully: $data');
      return data.map((json) => getEvent.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Events'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: publicEvents.isEmpty
              ? const Center(
                  child: Text(
                    'No available services.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Column(
                  children: _buildEventList(),
                ),
        ),
      ),
    );
  }

  List<Widget> _buildEventList() {
    // Sort the events by time
    publicEvents.sort((a, b) => a.date.compareTo(b.date));
    return publicEvents.map((getEvent event) {
      final formattedDate = DateFormat('MMMM d, y').format(event.date);
      final formattedTime = DateFormat('h:mm a').format(event.date);
      return Container(
        margin: const EdgeInsets.symmetric(
            vertical: 10.0), // Add vertical margin between cards
        padding: const EdgeInsets.all(15.0), // Add padding inside each card
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.brown.shade200),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(formattedDate),
                  Text(formattedTime),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: _getEventTypeColor(event.event_type),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      event.event_type,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JoinEventScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green, // Button background color
                    foregroundColor:
                        Colors.white, // Button text (foreground) color
                  ),
                  child: const Text('Join'),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getEventTypeColor(String eventType) {
    switch (eventType) {
      case 'Regular':
        return Colors.green;
      case 'Public':
        return Colors.brown;
      case 'Private':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
