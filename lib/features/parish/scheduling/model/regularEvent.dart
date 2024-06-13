import 'package:holink/features/parish/scheduling/model/regularEventDate.dart';

class RegularEvent {
  int id;
  String eventName;
  String description;
  String address;
  List<RegularEventDate> eventDates;

  RegularEvent({
    required this.id,
    required this.eventName,
    required this.description,
    required this.address,
    required this.eventDates,
  });

  factory RegularEvent.fromJson(Map<String, dynamic> json) {
    var list = json['dates'] as List;
    List<RegularEventDate> eventDatesList =
        list.map((i) => RegularEventDate.fromJson(i)).toList();

    return RegularEvent(
      id: json['event_id'],
      eventName: json['event_name'],
      description: json['description'],
      address: json['address'],
      eventDates: eventDatesList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map> eventDates = this.eventDates != null
        ? this.eventDates.map((i) => i.toJson()).toList()
        : [];
    return {
      'event_id': id,
      'event_name': eventName,
      'description': description,
      'address': address,
      'dates': eventDates,
    };
  }
}
