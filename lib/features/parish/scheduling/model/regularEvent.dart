class RegularEvent {
  final int id;
  final String eventName;
  final String description;
  final String address;
  RegularEvent({
    required this.id,
    required this.eventName,
    required this.description,
    required this.address,
  });

  factory RegularEvent.fromMap(Map<String, dynamic> map) {
    return RegularEvent(
      id: map['id'],
      eventName: map['event_name'],
      description: map['description'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_name': eventName,
      'description': description,
      'address': address
    };
  }
}
