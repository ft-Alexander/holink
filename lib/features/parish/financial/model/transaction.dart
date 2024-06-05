class Transaction {
  final int? transaction_id;
  final int? par_id;
  final String type;
  final String transaction_category;
  final DateTime date;
  final String amount;
  final String title;
  final String description;
  final String? sacramental_type;
  final String? special_event_type;
  final String archive_status;

  Transaction({
    this.transaction_id,
    this.par_id,
    required this.type,
    required this.transaction_category,
    required this.date,
    required this.amount,
    required this.title,
    required this.description,
    this.sacramental_type,
    this.special_event_type,
    required this.archive_status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transaction_id: json['transaction_id'] != null ? int.parse(json['transaction_id']) : null,
      par_id: json['par_id'] != null ? int.parse(json['par_id']) : null,
      type: json['type'],
      transaction_category: json['transaction_category'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      title: json['title'],
      description: json['description'],
      sacramental_type: json['sacramental_type'],
      special_event_type: json['special_event_type'],
      archive_status: json['archive_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transaction_id,
      'par_id': par_id,
      'type': type,
      'transaction_category': transaction_category,
      'date': date.toIso8601String(),
      'amount': amount,
      'title': title,
      'description': description,
      'sacramental_type': sacramental_type,
      'special_event_type': special_event_type,
      'archive_status': archive_status,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'transaction_id': transaction_id,
      'archive_status': archive_status,
    };
  }
}
