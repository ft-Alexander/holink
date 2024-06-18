import 'package:flutter/material.dart';
import 'package:holink/features/parish/scheduling/services/AddPersonDialog.dart';
import 'package:holink/features/parish/scheduling/services/EditForm.dart';
import 'package:intl/intl.dart';
import 'package:holink/features/parish/scheduling/model/get_all_event.dart';
import 'package:holink/features/parish/scheduling/services/event_service.dart';
import 'package:holink/features/parish/scheduling/model/priest.dart';
import 'package:holink/features/parish/scheduling/model/lector.dart';
import 'package:holink/features/parish/scheduling/model/sacristan.dart';

class EventCard extends StatefulWidget {
  final FetchEvents event;
  final VoidCallback onAddPerson;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  EventCard({
    Key? key,
    required this.event,
    required this.onAddPerson,
    required this.onEdit,
    required this.onCancel,
  }) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final EventService eventService = EventService();
  List<Priest> priests = [];
  List<Lector> lectors = [];
  List<Sacristan> sacristans = [];
  List<Priest> selectedPriests = [];
  List<Lector> selectedLectors = [];
  List<Sacristan> selectedSacristans = [];

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    try {
      final fetchedPriests = await eventService.fetchAllPriests();
      final fetchedLectors = await eventService.fetchAllLectors();
      final fetchedSacristans = await eventService.fetchAllSacristans();

      setState(() {
        priests = fetchedPriests;
        lectors = fetchedLectors;
        sacristans = fetchedSacristans;
      });
    } catch (e) {
      _showErrorSnackbar('Failed to fetch data: $e');
    }
  }

  Future<void> _saveSelectedPersons() async {
    try {
      final response = await eventService.saveSelectedPersons(
        widget.event.eventDateId!,
        selectedPriests.map((priest) => priest.id!).toList(),
        selectedLectors.map((lector) => lector.id!).toList(),
        selectedSacristans.map((sacristan) => sacristan.id!).toList(),
      );
      if (response['success']) {
        _showSuccessSnackbar('Successfully saved selected persons');
      } else {
        _showErrorSnackbar('Failed to save selected persons');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to save selected persons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.event.archiveStatus != 'Display') {
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
              _buildEventHeader(),
              const SizedBox(height: 6.0),
              _buildEventDetails(),
              const SizedBox(height: 12.0),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.event.eventId != null
                ? widget.event.eventName ?? 'Unknown Event'
                : widget.event.specialEventName ?? 'Special Event',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        _buildEventTypeLabel(widget.event.eventType),
      ],
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date: ${widget.event.eventDate?.toLocal().toString().split(' ')[0]}',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Time: ${DateFormat('h:mm a').format(widget.event.eventDate!.toLocal())}',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 4.0),
        if (widget.event.eventId != null)
          Text(
            'Location: ${widget.event.regularEventAddress ?? 'Unknown Address'}',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(Icons.person_add, Colors.green,
            () => _showAddPersonDialog(context)),
        _buildActionButton(Icons.edit, Colors.blue, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditForm(eventDateId: widget.event.eventDateId!),
            ),
          );
        }),
        _buildActionButton(Icons.cancel, Colors.red, () async {
          await _archiveRegularEvent(widget.event.eventDateId!);
          widget.onCancel();
        }),
      ],
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
    } catch (e) {
      _showErrorSnackbar('Failed to archive regular event: $e');
    }
  }

  void _showAddPersonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPersonDialog(
          priests: priests,
          selectedPriests: selectedPriests,
          lectors: lectors,
          selectedLectors: selectedLectors,
          sacristans: sacristans,
          selectedSacristans: selectedSacristans,
          onSave: _saveSelectedPersons,
        );
      },
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}
