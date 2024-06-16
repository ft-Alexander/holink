class Transaction {
  final int? transaction_id;
  final int? par_id;
  final String type;
  final String transaction_category;
  final DateTime date;
  final String amount;
  final String? sacramental_type;
  final String? special_event_type;
  final String archive_status;
  final String parishioner_access; // New field
  final String? purpose; // Add if it was not added previously
  final String? donated_by; // Add if it was not added previously
  final int bill1000;
  final int bill500;
  final int bill200;
  final int bill100;
  final int bill50;
  final int bill20;
  final int coin20;
  final int coin10;
  final int coin5;
  final int coin1;

  Transaction({
    this.transaction_id,
    this.par_id,
    required this.type,
    required this.transaction_category,
    required this.date,
    required this.amount,
    this.sacramental_type,
    this.special_event_type,
    required this.archive_status,
    required this.parishioner_access, // New field
    this.purpose,
    this.donated_by,
    required this.bill1000,
    required this.bill500,
    required this.bill200,
    required this.bill100,
    required this.bill50,
    required this.bill20,
    required this.coin20,
    required this.coin10,
    required this.coin5,
    required this.coin1,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transaction_id: json['transaction_id'] != null ? int.parse(json['transaction_id']) : null,
      par_id: json['par_id'] != null ? int.parse(json['par_id']) : null,
      type: json['type'],
      transaction_category: json['transaction_category'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      sacramental_type: json['sacramental_type'],
      special_event_type: json['special_event_type'],
      archive_status: json['archive_status'],
      parishioner_access: json['parishioner_access'],
      purpose: json['purpose'],
      donated_by: json['donated_by'],
      bill1000: json['bill1000'] != null ? int.parse(json['bill1000']) : 0,
      bill500: json['bill500'] != null ? int.parse(json['bill500']) : 0,
      bill200: json['bill200'] != null ? int.parse(json['bill200']) : 0,
      bill100: json['bill100'] != null ? int.parse(json['bill100']) : 0,
      bill50: json['bill50'] != null ? int.parse(json['bill50']) : 0,
      bill20: json['bill20'] != null ? int.parse(json['bill20']) : 0,
      coin20: json['coin20'] != null ? int.parse(json['coin20']) : 0,
      coin10: json['coin10'] != null ? int.parse(json['coin10']) : 0,
      coin5: json['coin5'] != null ? int.parse(json['coin5']) : 0,
      coin1: json['coin1'] != null ? int.parse(json['coin1']) : 0,
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
      'sacramental_type': sacramental_type,
      'special_event_type': special_event_type,
      'archive_status': archive_status,
      'parishioner_access': parishioner_access, // New field
      'purpose': purpose,
      'donated_by': donated_by,
      'bill1000': bill1000,
      'bill500': bill500,
      'bill200': bill200,
      'bill100': bill100,
      'bill50': bill50,
      'bill20': bill20,
      'coin20': coin20,
      'coin10': coin10,
      'coin5': coin5,
      'coin1': coin1,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'transaction_id': transaction_id,
      'archive_status': archive_status,
      'parishioner_access': parishioner_access,
    };
  }
}
