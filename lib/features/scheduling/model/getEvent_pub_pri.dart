class getEvent {
  final int s_id; // Change id to sId
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

  getEvent({
    required this.s_id, // Change id to sId
    required this.title,
    required this.date,
    required this.priest,
    required this.lectors,
    required this.sacristan,
    required this.address,
    required this.details,
    required this.sacraments,
    required this.event_type,
    required this.archive_status,
  });

  factory getEvent.fromJson(Map<String, dynamic> json) {
    return getEvent(
        s_id: json['s_id'] is int ? json['s_id'] : int.parse(json['s_id']),
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
      's_id': s_id, // Include s_id in the JSON
      'event_name': title,
      'event_datetime': date.toIso8601String(),
      'priest': priest,
      'lectors': lectors,
      'sacristan': sacristan,
      'address': address,
      'details': details,
      'sacraments': sacraments,
      'event_type': event_type,
      'archive_status': archive_status
    };
  }

  Map<String, dynamic> toMap() {
    return {
      's_id': s_id,
      'title': title,
      'date': date.toIso8601String(),
      'event_type': event_type,
      'archive_status': archive_status,
    };
  }
}
