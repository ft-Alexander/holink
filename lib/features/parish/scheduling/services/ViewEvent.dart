import 'package:flutter/material.dart';
import 'package:holink/features/parish/scheduling/model/get_all_event.dart';
import 'package:holink/features/parish/scheduling/model/get_event_priest.dart';
import 'package:holink/features/parish/scheduling/model/get_event_lectors.dart';
import 'package:holink/features/parish/scheduling/model/get_event_sacristan.dart';
import 'package:holink/features/parish/scheduling/services/event_service.dart';
import 'package:intl/intl.dart'; // Add this for formatting dates and times

class ViewEvent extends StatefulWidget {
  final int eventDateId;

  ViewEvent({required this.eventDateId});

  @override
  _ViewEventState createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  late EventService eventService;
  FetchEvents? event;
  List<GetEventPriest> priests = [];
  List<GetEventLectors> lectors = [];
  List<GetEventSacristan> sacristans = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    eventService = EventService();
    _fetchEventDetails();
  }

  Future<void> _fetchEventDetails() async {
    try {
      List<FetchEvents> events =
          await eventService.getEventsByDateId(widget.eventDateId);
      List<GetEventPriest> fetchedPriests =
          await eventService.getEventPriests(widget.eventDateId);
      List<GetEventLectors> fetchedLectors =
          await eventService.getEventLectors(widget.eventDateId);
      List<GetEventSacristan> fetchedSacristans =
          await eventService.getEventSacristans(widget.eventDateId);

      setState(() {
        if (events.isNotEmpty) {
          event = events.first;
          priests = fetchedPriests;
          lectors = fetchedLectors;
          sacristans = fetchedSacristans;
        } else {
          errorMessage = 'No event found for the given date ID.';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while fetching the event details: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : event != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                Center(
                                  child: Text(
                                    event!.eventName ??
                                        "${event!.specialEventName}'s ${event!.service} Request" ??
                                        'Unknown Event',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Date: ${event!.eventDate != null ? DateFormat('MMMM dd, yyyy').format(event!.eventDate!) : 'Unknown Date'}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Time: ${event!.eventDate != null ? DateFormat('h:mm a').format(event!.eventDate!.toLocal()) : 'Unknown Time'}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                if (event!.regularEventAddress != null)
                                  Text(
                                    'Location: ${event!.regularEventAddress}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                if (event!.specialEventAddress != null)
                                  Text(
                                    'Special Event Address: ${event!.specialEventAddress}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                if (event!.description != null)
                                  Text(
                                    'Description: ${event!.description}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                if (event!.skkNumber != null)
                                  Text(
                                    'SKK Number: ${event!.skkNumber}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                if (event!.landmark != null)
                                  Text(
                                    'Landmark: ${event!.landmark}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                if (event!.contactNumber != null)
                                  Text(
                                    'Contact Number: ${event!.contactNumber}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                if (event!.selectType != null)
                                  Text(
                                    'Select Type: ${event!.selectType}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                if (event!.service != null)
                                  Text(
                                    'Service: ${event!.service}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                if (priests.isNotEmpty) ...[
                                  SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.brown),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Assigned Priests:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...priests.map((priest) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.person,
                                                      color: Colors.green),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      priest.name ?? 'Unknown',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                                if (lectors.isNotEmpty) ...[
                                  SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.brown),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Assigned Lectors:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...lectors.map((lector) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.person,
                                                      color: Colors.green),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      lector.name ?? 'Unknown',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                                if (sacristans.isNotEmpty) ...[
                                  SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.brown),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Assigned Sacristans:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...sacristans.map((sacristan) =>
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.person,
                                                      color: Colors.green),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      sacristan.name ??
                                                          'Unknown',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Background color
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.white),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              child: Text(
                                'Back',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(child: Text('No event details available')),
    );
  }
}
