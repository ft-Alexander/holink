class GetEventPriest {
  int? id;
  int? eventDateId;
  int? priestId;
  String? name;
  String? contactInfo;

  GetEventPriest({
    this.id,
    this.eventDateId,
    this.priestId,
    this.name,
    this.contactInfo,
  });

  factory GetEventPriest.fromJson(Map<String, dynamic> json) {
    return GetEventPriest(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      eventDateId: json['event_date_id'] is int
          ? json['event_date_id']
          : int.tryParse(json['event_date_id'].toString()),
      priestId: json['priest_id'] is int
          ? json['priest_id']
          : int.tryParse(json['priest_id'].toString()),
      name: json['name'],
      contactInfo: json['contact_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date_id': eventDateId,
      'priest_id': priestId,
      'name': name,
      'contact_info': contactInfo,
    };
  }
}
