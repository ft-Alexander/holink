import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/scheduling/model/getEvent_pub_pri.dart';
import 'package:holink/features/scheduling/services/viewEvent.dart';
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
  localhost localhostInstance = new localhost();

  @override
  void initState() {
    super.initState();
    fetchAndSetEvents();
  }

  Future<void> fetchAndSetEvents() async {
    try {
      final events = await fetchEvents();
      setState(() {
        publicEvents =
            events.where((event) => event.event_type == "Public").toList();
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
        child: Column(
          children: _buildEventList(),
        ),
      ),
    );
  }

  List<Widget> _buildEventList() {
    // Sort the events by time
    publicEvents.sort((a, b) => a.date.compareTo(b.date));

    print('All public events count: ${publicEvents.length}');

    return publicEvents.map((getEvent event) {
      final formattedDate = DateFormat('MMMM d, y').format(event.date);
      final formattedTime = DateFormat('h:mm a').format(event.date);
      return GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewEventScreen(event: event),
            ),
          );
          if (result == true) {
            // Refresh events if the update was successful
            fetchAndSetEvents();
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.brown.shade200),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(formattedDate),
                    Text(formattedTime),
                    SizedBox(height: 5),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: _getEventTypeColor(event.event_type),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        event.event_type,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
