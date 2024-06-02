class Transaction {
  final int? transaction_id;
  final int? par_id;
  final String type;
  final DateTime date;
  final String amount;
  final String title;
  final String description;
  final String? sacramental_type;
  final String? special_event_type;
  final String? purpose;

  Transaction({
    this.transaction_id,
    this.par_id,
    required this.type,
    required this.date,
    required this.amount,
    required this.title,
    required this.description,
    this.sacramental_type,
    this.special_event_type,
    this.purpose,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transaction_id: json['transaction_id'],
      par_id: json['par_id'] != null ? int.parse(json['par_id']) : null,
      type: json['type'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      title: json['title'],
      description: json['description'],
      sacramental_type: json['sacramental_type'],
      special_event_type: json['special_event_type'],
      purpose: json['purpose'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transaction_id,
      'par_id': par_id,
      'type': type,
      'date': date.toIso8601String(),
      'amount': amount,
      'title': title,
      'description': description,
      'sacramental_type': sacramental_type,
      'special_event_type': special_event_type,
      'purpose': purpose,
    };
  }
}
