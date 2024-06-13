import 'package:holink/features/parish/scheduling/model/regularEvent.dart';

class RegularEventDate {
  int id;
  DateTime eventDate;
  int? priestId;
  int? lectorId;
  int? sacristanId;
  int regularEvent;
  RegularEvent? eventDetails;
  String archiveStatus;

  RegularEventDate({
    required this.id,
    required this.eventDate,
    this.priestId,
    this.lectorId,
    this.sacristanId,
    required this.regularEvent,
    this.eventDetails,
    required this.archiveStatus,
  });

  factory RegularEventDate.fromJson(Map<String, dynamic> json) {
    return RegularEventDate(
      id: json['event_date_id'],
      eventDate: DateTime.parse(json['event_date']),
      priestId: json['priest_id'],
      lectorId: json['lector_id'],
      sacristanId: json['sacristan_id'],
      regularEvent: json['regular_event'],
      archiveStatus: json['archive_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_date_id': id,
      'event_date': eventDate.toIso8601String(),
      'priest_id': priestId,
      'lector_id': lectorId,
      'sacristan_id': sacristanId,
      'regular_event': regularEvent,
      'archive_status': archiveStatus,
    };
  }
}
