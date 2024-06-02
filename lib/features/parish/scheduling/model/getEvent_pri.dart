class PrivateEvent {
  final int p_id;
  final int s_id;
  final DateTime date_availed;
  final DateTime scheduled_date;
  final String service;
  final String serviceType;
  final String fullName;
  final String skkNumber;
  final String address;
  final String landmark;
  final String contactNumber;
  final String selectedType;
  final String archive_status;

  PrivateEvent(
      {required this.p_id,
      required this.s_id,
      required this.date_availed,
      required this.scheduled_date,
      required this.service,
      required this.serviceType,
      required this.fullName,
      required this.skkNumber,
      required this.address,
      required this.landmark,
      required this.contactNumber,
      required this.selectedType,
      required this.archive_status});

  factory PrivateEvent.fromJson(Map<String, dynamic> json) {
    return PrivateEvent(
        p_id: json['p_id'] ?? 0,
        s_id: json['s_id'] ?? 0,
        date_availed: DateTime.parse(
            json['availed_date'] ?? DateTime.now().toIso8601String()),
        scheduled_date: DateTime.parse(
            json['scheduled_date'] ?? DateTime.now().toIso8601String()),
        service: json['service'] ?? '',
        serviceType: json['serviceType'] ?? '',
        fullName: json['fullName'] ?? '',
        skkNumber: json['skk_number'] ?? '',
        address: json['address'] ?? '',
        landmark: json['landmark'] ?? '',
        contactNumber: json['contact_number'] ?? '',
        selectedType: json['selected_type'] ?? '',
        archive_status: json['archive_status']);
  }
}
