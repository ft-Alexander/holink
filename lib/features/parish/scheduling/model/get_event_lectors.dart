class GetEventLectors {
  int? id;
  int? eventDateId;
  int? lectorsId;
  String? name;
  String? contactInfo;

  GetEventLectors({
    this.id,
    this.eventDateId,
    this.lectorsId,
    this.name,
    this.contactInfo,
  });

  factory GetEventLectors.fromJson(Map<String, dynamic> json) {
    return GetEventLectors(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      eventDateId: json['event_date_id'] is int
          ? json['event_date_id']
          : int.tryParse(json['event_date_id'].toString()),
      lectorsId: json['lectorsId'] is int
          ? json['lectorsId']
          : int.tryParse(json['lectorsId'].toString()),
      name: json['name'],
      contactInfo: json['contact_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date_id': eventDateId,
      'lectorsId': lectorsId,
      'name': name,
      'contact_info': contactInfo,
    };
  }
}
