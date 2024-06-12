class EventPriest {
  final int id;
  final int eventDate;
  final int priestId;

  EventPriest(
      {required this.id, required this.eventDate, required this.priestId});

  factory EventPriest.fromMap(Map<String, dynamic> map) {
    return EventPriest(
      id: map['id'],
      eventDate: map['event_date'],
      priestId: map['priest_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_date': eventDate,
      'priest_id': priestId,
    };
  }
}
