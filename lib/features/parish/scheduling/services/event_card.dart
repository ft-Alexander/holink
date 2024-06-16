import 'package:flutter/material.dart';
import 'package:holink/features/parish/scheduling/services/event_service.dart';
import 'package:intl/intl.dart';
import 'package:holink/features/parish/scheduling/model/regularEventDate.dart';

class EventCard extends StatelessWidget {
  final RegularEventDate event;
  final VoidCallback onAddPerson;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  final EventService eventService = EventService();

  EventCard({
    Key? key,
    required this.event,
    required this.onAddPerson,
    required this.onEdit,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (event.archiveStatus != 'Display') {
      return SizedBox.shrink();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.eventDetails!.eventName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  _buildEventTypeLabel(event.eventType),
                ],
              ),
              const SizedBox(height: 6.0),
              Text(
                'Date: ${event.eventDate.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Time: ${DateFormat('h:mm a').format(event.eventDate.toLocal())}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Location: ${event.eventDetails!.address}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                      Icons.person_add, Colors.green, onAddPerson),
                  _buildActionButton(Icons.edit, Colors.blue, onEdit),
                  _buildActionButton(Icons.cancel, Colors.red, () async {
                    // Call the eventService to archive the event
                    await _archiveRegularEvent(event.id);
                    // Call the onCancel callback to refresh the event list
                    onCancel();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTypeLabel(String? eventType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: _getEventTypeColor(eventType),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        eventType ?? 'Unknown',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getEventTypeColor(String? eventType) {
    switch (eventType) {
      case 'Regular':
        return Colors.green;
      case 'Mass':
        return Colors.orange;
      case 'Special':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  Widget _buildActionButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        minimumSize: const Size(40, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: color,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Future<void> _archiveRegularEvent(int eventId) async {
    try {
      await eventService.archiveRegularEvent(eventId);
      // Handle successful archive (if needed)
    } catch (e) {
      // Handle error (if needed)
      print('Failed to archive regular event: $e');
    }
  }
}
