class GetEventSacristan {
  int? id;
  int? eventDateId;
  int? sacristanId;
  String? name;
  String? contactInfo;

  GetEventSacristan({
    this.id,
    this.eventDateId,
    this.sacristanId,
    this.name,
    this.contactInfo,
  });

  factory GetEventSacristan.fromJson(Map<String, dynamic> json) {
    return GetEventSacristan(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      eventDateId: json['event_date_id'] is int
          ? json['event_date_id']
          : int.tryParse(json['event_date_id'].toString()),
      sacristanId: json['sacristan_id'] is int
          ? json['sacristan_id']
          : int.tryParse(json['sacristan_id'].toString()),
      name: json['name'],
      contactInfo: json['contact_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date_id': eventDateId,
      'sacristan_id': sacristanId,
      'name': name,
      'contact_info': contactInfo,
    };
  }
}
