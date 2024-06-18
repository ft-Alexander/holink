import 'package:flutter/material.dart';
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

      // Print statements to display fetched data
      print(
          "Fetched Priests: ${priests.map((priest) => priest.name).toList()}");
      print(
          "Fetched Lectors: ${lectors.map((lector) => lector.name).toList()}");
      print(
          "Fetched Sacristans: ${sacristans.map((sacristan) => sacristan.name).toList()}");
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  Future<void> _saveSelectedPersons() async {
    try {
      print(
          'Selected Priests: ${selectedPriests.map((priest) => priest.name).toList()}');
      print(
          'Selected Lectors: ${selectedLectors.map((lector) => lector.name).toList()}');
      print(
          'Selected Sacristans: ${selectedSacristans.map((sacristan) => sacristan.name).toList()}');

      final response = await eventService.saveSelectedPersons(
        widget.event.eventDateId!,
        selectedPriests.map((priest) => priest.id!).toList(),
        selectedLectors.map((lector) => lector.id!).toList(),
        selectedSacristans.map((sacristan) => sacristan.id!).toList(),
      );
      print('Response: $response');
      if (response['success']) {
        print('Successfully saved selected persons');
      } else {
        print('Failed to save selected persons');
      }
    } catch (e) {
      print('Failed to save selected persons: $e');
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
              Row(
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
              ),
              const SizedBox(height: 6.0),
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
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Icons.person_add, Colors.green,
                      () => _showAddPersonDialog(context)),
                  _buildActionButton(Icons.edit, Colors.blue, widget.onEdit),
                  _buildActionButton(Icons.cancel, Colors.red, () async {
                    await _archiveRegularEvent(widget.event.eventDateId!);
                    widget.onCancel();
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
    } catch (e) {
      print('Failed to archive regular event: $e');
    }
  }

  void _showAddPersonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add Person'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMultiSelectDropdown<Priest>(
                      label: 'Select Priests',
                      items: priests,
                      selectedItems: selectedPriests,
                      displayString: (priest) => priest.name,
                      onChanged: (Priest? value) {
                        setState(() {
                          if (selectedPriests.contains(value)) {
                            selectedPriests.remove(value);
                          } else {
                            selectedPriests.add(value!);
                          }
                        });
                      },
                      parentSetState: setState,
                    ),
                    SizedBox(height: 16.0),
                    _buildMultiSelectDropdown<Lector>(
                      label: 'Select Lectors',
                      items: lectors,
                      selectedItems: selectedLectors,
                      displayString: (lector) => lector.name,
                      onChanged: (Lector? value) {
                        setState(() {
                          if (selectedLectors.contains(value)) {
                            selectedLectors.remove(value);
                          } else {
                            selectedLectors.add(value!);
                          }
                        });
                      },
                      parentSetState: setState,
                    ),
                    SizedBox(height: 16.0),
                    _buildMultiSelectDropdown<Sacristan>(
                      label: 'Select Sacristans',
                      items: sacristans,
                      selectedItems: selectedSacristans,
                      displayString: (sacristan) => sacristan.name,
                      onChanged: (Sacristan? value) {
                        setState(() {
                          if (selectedSacristans.contains(value)) {
                            selectedSacristans.remove(value);
                          } else {
                            selectedSacristans.add(value!);
                          }
                        });
                      },
                      parentSetState: setState,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await _saveSelectedPersons();
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Assign'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMultiSelectDropdown<T>({
    required String label,
    required List<T> items,
    required List<T> selectedItems,
    required String Function(T) displayString,
    required ValueChanged<T?> onChanged,
    required StateSetter parentSetState,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8.0),
        DropdownButtonFormField<T>(
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(displayString(item)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
        ),
        Wrap(
          children: selectedItems.map((T item) {
            return Chip(
              label: Text(displayString(item)),
              onDeleted: () {
                parentSetState(() {
                  selectedItems.remove(item);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
