class Event {
  final String title;
  // final DateTime date;
  // , required this.date
  Event({required this.title});

  String toStringTitle() => this.title;
  // String toStringDate() => this.date.toString();
}
