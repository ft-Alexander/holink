import 'package:holink/features/parish/scheduling/model/regularEvent.dart';

class RegularEventDate {
  int id;
  DateTime eventDate;
  int regularEvent;
  RegularEvent? eventDetails;
  String archiveStatus;
  String eventType;

  RegularEventDate({
    required this.id,
    required this.eventDate,
    required this.regularEvent,
    this.eventDetails,
    required this.archiveStatus,
    required this.eventType,
  });

  factory RegularEventDate.fromJson(Map<String, dynamic> json) {
    return RegularEventDate(
        id: json['event_date_id'] is int
            ? json['event_date_id']
            : int.tryParse(json['event_date_id'].toString()) ?? 0,
        eventDate: DateTime.parse(json['event_date']),
        regularEvent: json['event_id'] is int
            ? json['event_id']
            : int.tryParse(json['event_id'].toString()) ?? 0,
        eventDetails: json.containsKey('event_name') &&
                json.containsKey('description') &&
                json.containsKey('address')
            ? RegularEvent(
                id: json['event_id'] is int
                    ? json['event_id']
                    : int.tryParse(json['event_id'].toString()) ?? 0,
                eventName: json['event_name'],
                description: json['description'],
                address: json['address'],
                eventDates: [],
              )
            : null,
        archiveStatus: json['archive_status'],
        eventType: json['event_type']);
  }

  Map<String, dynamic> toJson() {
    return {
      'event_date_id': id,
      'event_date': eventDate.toIso8601String(),
      'regular_event': regularEvent,
      'event_details': eventDetails?.toJson(),
      'archive_status': archiveStatus,
      'event_type': eventType
    };
  }
}
