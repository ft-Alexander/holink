class Lector {
  final int id;
  final String name;
  String? contactInfo;

  Lector({required this.id, required this.name, this.contactInfo});

  factory Lector.fromJson(Map<String, dynamic> json) {
    return Lector(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      name: json['name'],
      contactInfo: json['contact_info'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact_info': contactInfo,
    };
  }
}
