class EventSacristan {
  final int id;
  final int eventDate;
  final int sacristanId;

  EventSacristan(
      {required this.id, required this.eventDate, required this.sacristanId});

  factory EventSacristan.fromMap(Map<String, dynamic> map) {
    return EventSacristan(
      id: map['id'],
      eventDate: map['event_date'],
      sacristanId: map['sacristan_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_date': eventDate,
      'sacristan_id': sacristanId,
    };
  }
}
