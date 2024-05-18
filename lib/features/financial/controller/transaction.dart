class Transaction {
  final String title;
  final String transactionId;
  final String employeeId;
  final String type;
  final String date;
  final String amount;
  final String description;
  final String? sacramentalType;
  final String? specialEventType;
  final String? purpose;

  Transaction({
    required this.title,
    required this.transactionId,
    required this.employeeId,
    required this.type,
    required this.date,
    required this.amount,
    required this.description,
    this.sacramentalType,
    this.specialEventType,
    this.purpose,
  });
}
