class RegularEventDate {
  final int id;
  final DateTime eventDate;
  int? priestId;
  int? lectorId;
  int? sacristanId;
  final int regularEvent;
  String? archiveStatus;

  RegularEventDate({
    required this.id,
    required this.eventDate,
    required this.priestId,
    required this.lectorId,
    required this.sacristanId,
    required this.regularEvent,
    this.archiveStatus,
  });

  factory RegularEventDate.fromMap(Map<String, dynamic> map) {
    return RegularEventDate(
      id: map['id'],
      eventDate: DateTime.parse(map['event_date']),
      priestId: map['priest_id'],
      lectorId: map['lector_id'],
      sacristanId: map['sacristan_id'],
      regularEvent: map['regular_event'],
      archiveStatus: map['archive_status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_date': eventDate.toIso8601String(),
      'priest_id': priestId,
      'lector_id': lectorId,
      'sacristan_id': sacristanId,
      'regular_event': regularEvent,
      'archive_status': archiveStatus
    };
  }
}
