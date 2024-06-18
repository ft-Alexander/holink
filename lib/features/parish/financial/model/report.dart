class Report {
  final int? report_id;
  final int? par_id;
  final String parish_name;
  final String date;
  final String status;
  final String archive_status;
  final double massesFunds;
  final double massCollections;
  final double stoleFees;
  final double otherReceipts;
  final double communicationExpenses;
  final double electricityWaterBill;
  final double officeSupplies;
  final double transportation;
  final double salariesWages;
  final double sssHdmfPhilHealth;
  final double socialServicesCharities;
  final double food;
  final double decorsoSustentoPPGP;
  final double otherParishExpenses;
  final double totalIncome;
  final double totalExpenses;
  final double netDeficit;
  final String parishioners_access; // new field
  final String report_type; // new field

  Report({
    this.report_id,
    this.par_id,
    required this.parish_name,
    required this.date,
    required this.status,
    required this.archive_status,
    required this.massesFunds,
    required this.massCollections,
    required this.stoleFees,
    required this.otherReceipts,
    required this.communicationExpenses,
    required this.electricityWaterBill,
    required this.officeSupplies,
    required this.transportation,
    required this.salariesWages,
    required this.sssHdmfPhilHealth,
    required this.socialServicesCharities,
    required this.food,
    required this.decorsoSustentoPPGP,
    required this.otherParishExpenses,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netDeficit,
    this.parishioners_access = 'hidden', // default value
    required this.report_type, // new field
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      report_id: json['report_id'] != null ? int.parse(json['report_id']) : null,
      par_id: json['par_id'] != null ? int.parse(json['par_id']) : null,
      parish_name: json['parish_name'],
      date: json['date'],
      status: json['status'],
      archive_status: json['archive_status'],
      massesFunds: double.parse(json['massesFunds']),
      massCollections: double.parse(json['massCollections']),
      stoleFees: double.parse(json['stoleFees']),
      otherReceipts: double.parse(json['otherReceipts']),
      communicationExpenses: double.parse(json['communicationExpenses']),
      electricityWaterBill: double.parse(json['electricityWaterBill']),
      officeSupplies: double.parse(json['officeSupplies']),
      transportation: double.parse(json['transportation']),
      salariesWages: double.parse(json['salariesWages']),
      sssHdmfPhilHealth: double.parse(json['sssHdmfPhilHealth']),
      socialServicesCharities: double.parse(json['socialServicesCharities']),
      food: double.parse(json['food']),
      decorsoSustentoPPGP: double.parse(json['decorsoSustentoPPGP']),
      otherParishExpenses: double.parse(json['otherParishExpenses']),
      totalIncome: double.parse(json['totalIncome']),
      totalExpenses: double.parse(json['totalExpenses']),
      netDeficit: double.parse(json['netDeficit']),
      parishioners_access: json['parishioners_access'] ?? 'hidden', // new field
      report_type: json['report_type'], // new field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'report_id': report_id,
      'par_id': par_id,
      'parish_name': parish_name,
      'date': date,
      'status': status,
      'archive_status': archive_status,
      'massesFunds': massesFunds.toStringAsFixed(2),
      'massCollections': massCollections.toStringAsFixed(2),
      'stoleFees': stoleFees.toStringAsFixed(2),
      'otherReceipts': otherReceipts.toStringAsFixed(2),
      'communicationExpenses': communicationExpenses.toStringAsFixed(2),
      'electricityWaterBill': electricityWaterBill.toStringAsFixed(2),
      'officeSupplies': officeSupplies.toStringAsFixed(2),
      'transportation': transportation.toStringAsFixed(2),
      'salariesWages': salariesWages.toStringAsFixed(2),
      'sssHdmfPhilHealth': sssHdmfPhilHealth.toStringAsFixed(2),
      'socialServicesCharities': socialServicesCharities.toStringAsFixed(2),
      'food': food.toStringAsFixed(2),
      'decorsoSustentoPPGP': decorsoSustentoPPGP.toStringAsFixed(2),
      'otherParishExpenses': otherParishExpenses.toStringAsFixed(2),
      'totalIncome': totalIncome.toStringAsFixed(2),
      'totalExpenses': totalExpenses.toStringAsFixed(2),
      'netDeficit': netDeficit.toStringAsFixed(2),
      'parishioners_access': parishioners_access, // new field
      'report_type': report_type, // new field
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'report_id': report_id,
      'archive_status': archive_status,
      'parishioners_access': parishioners_access,
    };
  }
}
