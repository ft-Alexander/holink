class getMnistry {
  final int id;
  int? lector_id;
  DateTime? lector_date;
  int? priest_id;
  DateTime? priest_date;
  int? sacristan_id;
  DateTime? sacristan_date;

  getMnistry({
    required this.id,
    this.lector_id,
    this.lector_date,
    this.priest_id,
    this.priest_date,
    this.sacristan_id,
    this.sacristan_date,
  });
  factory getMnistry.fromAssignments(
      int eventDateId, Map<String, dynamic> assignments) {
    return getMnistry(
      id: eventDateId,
      lector_id: assignments['lectors'].isNotEmpty
          ? assignments['lectors'][0]['id']
          : null,
      lector_date: assignments['lectors'].isNotEmpty
          ? DateTime.parse(assignments['lectors'][0]['date'])
          : null,
      priest_id: assignments['priests'].isNotEmpty
          ? assignments['priests'][0]['id']
          : null,
      priest_date: assignments['priests'].isNotEmpty
          ? DateTime.parse(assignments['priests'][0]['date'])
          : null,
      sacristan_id: assignments['sacristans'].isNotEmpty
          ? assignments['sacristans'][0]['id']
          : null,
      sacristan_date: assignments['sacristans'].isNotEmpty
          ? DateTime.parse(assignments['sacristans'][0]['date'])
          : null,
    );
  }

  @override
  String toString() {
    return 'getMnistry{id: $id, lector_id: $lector_id, lector_date: $lector_date, priest_id: $priest_id, priest_date: $priest_date, sacristan_id: $sacristan_id, sacristan_date: $sacristan_date}';
  }
}
