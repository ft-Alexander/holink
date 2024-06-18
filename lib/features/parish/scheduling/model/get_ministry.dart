class getMinistry {
  List<MinistryData> priests;
  List<MinistryData> lectors;
  List<MinistryData> sacristans;

  getMinistry({
    required this.priests,
    required this.lectors,
    required this.sacristans,
  });

  factory getMinistry.fromJson(Map<String, dynamic> json) {
    return getMinistry(
      priests: (json['priests'] as List)
          .map((item) => MinistryData.fromJson(item))
          .toList(),
      lectors: (json['lectors'] as List)
          .map((item) => MinistryData.fromJson(item))
          .toList(),
      sacristans: (json['sacristans'] as List)
          .map((item) => MinistryData.fromJson(item))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'getMinistry{priests: $priests, lectors: $lectors, sacristans: $sacristans}';
  }
}

class MinistryData {
  int? id;
  int? ministryId;
  int? event_date;

  MinistryData({
    required this.id,
    this.ministryId,
    this.event_date,
  });

  factory MinistryData.fromJson(Map<String, dynamic> json) {
    return MinistryData(
      id: json['id'],
      ministryId:
          json['priest_id'] ?? json['lector_id'] ?? json['sacristan_id'],
      event_date: json['event_date'] != null
          ? int.tryParse(json['event_date'].toString())
          : null,
    );
  }

  @override
  String toString() {
    return 'MinistryData{id: $id, ministryId: $ministryId, event_date: $event_date}';
  }
}
