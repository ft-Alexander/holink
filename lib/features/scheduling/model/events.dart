class Event {
  final String title;
  final DateTime date;
  final String priest;
  final String lectors;
  final String sacristan;
  final String address;
  final String details;
  final String sacraments;
  final String event_type;
  String archive_status;

  Event(
      {required this.title,
      required this.date,
      required this.priest,
      required this.lectors,
      required this.sacristan,
      required this.address,
      required this.details,
      required this.sacraments,
      required this.event_type,
      required this.archive_status});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        title: json['event_name'] as String,
        date: DateTime.parse(json['event_datetime'] as String),
        priest: json['priest'] as String,
        lectors: json['lectors'] as String,
        sacristan: json['sacristan'] as String,
        address: json['address'] as String,
        details: json['details'] as String,
        sacraments: json['sacraments'] as String,
        event_type: json['event_type'] as String,
        archive_status: json['archive_status'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'event_name': title,
      'event_datetime': date.toIso8601String(),
      'priest': priest,
      'lectors': lectors,
      'sacristan': sacristan,
      'address': address,
      'details': details,
      'sacraments': sacraments,
      'eventType': event_type,
      'archive_status': archive_status
    };
  }
}
