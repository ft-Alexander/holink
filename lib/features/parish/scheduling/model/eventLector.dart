class EventLector {
  final int id;
  final int eventDate;
  final int lectorId;

  EventLector(
      {required this.id, required this.eventDate, required this.lectorId});

  factory EventLector.fromMap(Map<String, dynamic> map) {
    return EventLector(
      id: map['id'],
      eventDate: map['event_date'],
      lectorId: map['lector_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_date': eventDate,
      'lector_id': lectorId,
    };
  }
}
