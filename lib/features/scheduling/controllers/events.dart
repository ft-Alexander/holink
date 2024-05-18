class Event {
  final String title;
  final String priest;
  final String lectors;
  final String sacristan;
  final String address;
  final String details;
  final DateTime date;

  Event(
      {required this.title,
      required this.date,
      required this.priest,
      required this.lectors,
      required this.sacristan,
      required this.address,
      required this.details});

  String toStringTitle() => this.title;
  DateTime toStringDate() => this.date;
}
