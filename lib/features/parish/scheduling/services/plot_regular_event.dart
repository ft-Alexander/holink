import 'package:flutter/material.dart';
import 'package:holink/features/parish/scheduling/model/regularEvent.dart';
import 'package:holink/features/parish/scheduling/model/regularEventDate.dart';
import 'package:intl/intl.dart';
import '../services/event_service.dart';
import 'form_fields.dart';

class RegularEventForm extends StatefulWidget {
  const RegularEventForm({super.key});

  @override
  _RegularEventFormState createState() => _RegularEventFormState();
}

class _RegularEventFormState extends State<RegularEventForm> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priestIdController = TextEditingController();
  final _lectorIdController = TextEditingController();
  final _sacristanIdController = TextEditingController();
  final _addressController = TextEditingController();
  final EventService _eventService = EventService();

  final List<DateTime> _selectedDates = [];
  final List<String> _repeatOptions = [
    "Every Monday",
    "Every Tuesday",
    "Every Wednesday",
    "Every Thursday",
    "Every Friday",
    "Every Saturday",
    "Every Sunday"
  ];
  final Map<String, List<TimeOfDay>> _selectedRepeatOptions = {};
  final Map<DateTime, TimeOfDay> _specificDatesWithTimes = {};
  String? _selectedRepeatOption;
  int _selectedMonth = DateTime.now().month;
  Map<DateTime, List<RegularEventDate>> _events = {};

  Map<DateTime, List<RegularEventDate>> _mapEventsToDates(
      List<RegularEvent> events) {
    final Map<DateTime, List<RegularEventDate>> mappedEvents = {};
    for (var event in events) {
      for (var eventDate in event.eventDates) {
        // Access the eventDates list
        final date = DateTime(eventDate.eventDate.year,
            eventDate.eventDate.month, eventDate.eventDate.day);
        if (mappedEvents[date] == null) {
          mappedEvents[date] = [];
        }
        mappedEvents[date]!.add(eventDate);
      }
    }
    return mappedEvents;
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _priestIdController.dispose();
    _lectorIdController.dispose();
    _sacristanIdController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null &&
        picked.month == _selectedMonth &&
        !_selectedDates.contains(picked)) {
      final time =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) {
        setState(() {
          _selectedDates.add(picked);
          _specificDatesWithTimes[picked] = time;
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context, String day) async {
    final picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _selectedRepeatOptions.putIfAbsent(day, () => []).add(picked);
      });
      _generateRepeatDates(day, picked);
    }
  }

  void _generateRepeatDates(String day, TimeOfDay time) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, _selectedMonth + 1, 0).day;
    final dayNumber = _dayStringToNumber(day);

    final newDates = List.generate(daysInMonth, (i) {
      final date = DateTime(now.year, _selectedMonth, i + 1);
      return date.weekday == dayNumber
          ? DateTime(date.year, date.month, date.day, time.hour, time.minute)
          : null;
    }).whereType<DateTime>().toList();

    setState(() {
      _selectedDates.addAll(newDates);
      for (var date in newDates) {
        _specificDatesWithTimes[date] = time;
      }
    });
  }

  void _plotForm() async {
    if (_formKey.currentState!.validate()) {
      RegularEvent event = RegularEvent(
        id: 0,
        eventName: _eventNameController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        eventDates: [],
      );

      int? eventId = await _eventService.saveRegularEvent(event);

      if (eventId != null) {
        for (DateTime date in _selectedDates) {
          TimeOfDay? time = _specificDatesWithTimes[date];
          DateTime eventDateTime = DateTime(date.year, date.month, date.day,
              time?.hour ?? 0, time?.minute ?? 0);

          RegularEventDate eventDate = RegularEventDate(
            id: 0,
            eventDate: eventDateTime,
            priestId: int.tryParse(_priestIdController.text),
            lectorId: int.tryParse(_lectorIdController.text),
            sacristanId: int.tryParse(_sacristanIdController.text),
            regularEvent: eventId,
            archiveStatus: 'Display',
          );

          bool success = await _eventService.saveRegularEventDate(eventDate);
          if (!success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Failed to save some event dates.'),
            ));
            print('Error: Failed to save event date for $eventDate');
            return;
          }
        }

        setState(() {
          _selectedDates.clear();
          _specificDatesWithTimes.clear();
        });

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to save the event.'),
        ));
        print('Error: Failed to save event');
      }
    }
  }

  int _dayStringToNumber(String day) {
    const days = {
      "Every Monday": DateTime.monday,
      "Every Tuesday": DateTime.tuesday,
      "Every Wednesday": DateTime.wednesday,
      "Every Thursday": DateTime.thursday,
      "Every Friday": DateTime.friday,
      "Every Saturday": DateTime.saturday,
      "Every Sunday": DateTime.sunday,
    };
    return days[day] ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text('Create Regular Event',
                style: TextStyle(color: Colors.white))),
        backgroundColor: const Color.fromRGBO(179, 120, 64, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildDropdownField<int>(
                  "Select Month",
                  _selectedMonth,
                  List.generate(12 - now.month + 1, (index) {
                    return DropdownMenuItem(
                      value: now.month + index,
                      child: Text(
                          DateFormat.MMMM()
                              .format(DateTime(now.year, now.month + index)),
                          style: const TextStyle(color: Colors.black54)),
                    );
                  }),
                  (newValue) {
                    setState(() {
                      _selectedMonth = newValue!;
                      _selectedDates.clear();
                      _specificDatesWithTimes.clear();
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                buildTextField(_eventNameController, 'Event Name'),
                const SizedBox(height: 16.0),
                buildTextField(_descriptionController, 'Description'),
                const SizedBox(height: 16.0),
                buildTextField(_addressController, 'Address'),
                const SizedBox(height: 16.0),
                buildDropdownField<String>(
                  "Select Repeat Option",
                  _selectedRepeatOption,
                  _repeatOptions.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: Colors.black54)),
                    );
                  }).toList(),
                  (newValue) {
                    setState(() {
                      _selectedRepeatOption = newValue;
                    });
                    if (newValue != null) _selectTime(context, newValue);
                  },
                ),
                const SizedBox(height: 16.0),
                _buildSelectedRepeatOptions(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(179, 120, 64, 1.0),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Select Specific Dates"),
                ),
                _buildSelectedDatesChips(),
                const SizedBox(height: 16.0),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedRepeatOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _selectedRepeatOptions.entries.expand((entry) {
        return entry.value.map((time) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${entry.key} at ${time.format(context)}",
                  style: const TextStyle(fontSize: 16, color: Colors.black87)),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _selectedRepeatOptions[entry.key]!.remove(time);
                    if (_selectedRepeatOptions[entry.key]!.isEmpty) {
                      _selectedRepeatOptions.remove(entry.key);
                    }
                    _selectedDates.removeWhere((date) =>
                        date.weekday == _dayStringToNumber(entry.key) &&
                        date.hour == time.hour &&
                        date.minute == time.minute);
                    _specificDatesWithTimes.removeWhere((date, t) =>
                        date.weekday == _dayStringToNumber(entry.key) &&
                        date.hour == time.hour &&
                        date.minute == time.minute);
                  });
                },
              ),
            ],
          );
        }).toList();
      }).toList(),
    );
  }

  Widget _buildSelectedDatesChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: _selectedDates.map((date) {
        return InputChip(
          label: Text(
              "${"${date.toLocal()}".split(' ')[0]} at ${_specificDatesWithTimes[date]?.format(context) ?? ""}"),
          labelStyle: const TextStyle(color: Colors.black87),
          onDeleted: () {
            setState(() {
              _selectedDates.remove(date);
              _specificDatesWithTimes.remove(date);
            });
          },
          onPressed: () => _editDateTime(context, date),
        );
      }).toList(),
    );
  }

  void _editDateTime(BuildContext context, DateTime date) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (newDate != null) {
      final newTime = await showTimePicker(
        context: context,
        initialTime:
            _specificDatesWithTimes[date] ?? TimeOfDay.fromDateTime(date),
      );
      if (newTime != null) {
        final newDateTime = DateTime(newDate.year, newDate.month, newDate.day,
            newTime.hour, newTime.minute);
        setState(() {
          _selectedDates.remove(date);
          _specificDatesWithTimes.remove(date);
          _selectedDates.add(newDateTime);
          _specificDatesWithTimes[newDateTime] = newTime;
        });
      }
    }
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _plotForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF57CA63),
            foregroundColor: Colors.white,
          ),
          child: const Text('Plot'),
        ),
      ],
    );
  }
}
