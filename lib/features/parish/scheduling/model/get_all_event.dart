class FetchEvents {
  int? eventDateId;
  DateTime? eventDate;
  String? archiveStatus;
  String? eventType;
  int? eventId;
  String? eventName;
  String? description;
  String? regularEventAddress;
  int? specialEventId;
  String? specialEventName;
  String? skkNumber;
  String? specialEventAddress;
  String? landmark;
  String? contactNumber;
  String? availedDate;
  String? selectType;
  String? service;

  FetchEvents({
    this.eventDateId,
    this.eventDate,
    this.archiveStatus,
    this.eventType,
    this.eventId,
    this.eventName,
    this.description,
    this.regularEventAddress,
    this.specialEventId,
    this.specialEventName,
    this.skkNumber,
    this.specialEventAddress,
    this.landmark,
    this.contactNumber,
    this.availedDate,
    this.selectType,
    this.service,
  });

  factory FetchEvents.fromJson(Map<String, dynamic> json) {
    return FetchEvents(
      eventDateId: json['event_date_id'] is int
          ? json['event_date_id']
          : int.tryParse(json['event_date_id'].toString()),
      eventDate: json.containsKey('event_date') && json['event_date'] != null
          ? DateTime.parse(json['event_date'])
          : null,
      archiveStatus: json['archive_status'],
      eventType: json['event_type'],
      eventId: json['event_id'] is int
          ? json['event_id']
          : int.tryParse(json['event_id'].toString()),
      eventName: json['event_name'],
      description: json['description'],
      regularEventAddress: json['regular_event_address'],
      specialEventId: json['special_event_id'] is int
          ? json['special_event_id']
          : int.tryParse(json['special_event_id'].toString()),
      specialEventName: json['special_event_name'],
      skkNumber: json['skk_number'],
      specialEventAddress: json['special_event_address'],
      landmark: json['landmark'],
      contactNumber: json['contact_number'],
      availedDate: json['availed_date'],
      selectType: json['select_type'],
      service: json['service'],
    );
  }
}
