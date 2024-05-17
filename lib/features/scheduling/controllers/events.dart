class Event {
  final String title;
  final DateTime date;

  Event({required this.title, required this.date});

  String toStringTitle() => this.title;
  DateTime toStringDate() => this.date;
}
