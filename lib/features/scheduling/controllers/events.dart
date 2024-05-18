class Event {
  final String title;
  final DateTime date;
  final String priest;
  final String lectors;
  final String sacristan;
  final String address;
  final String details;

  Event({
    required this.title,
    required this.date,
    required this.priest,
    required this.lectors,
    required this.sacristan,
    required this.address,
    required this.details,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['event_name'] as String,
      date: DateTime.parse(json['event_datetime'] as String),
      priest: json['priest'] as String,
      lectors: json['lectors'] as String,
      sacristan: json['sacristan'] as String,
      address: json['address'] as String,
      details: json['details'] as String,
    );
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
    };
  }
}
