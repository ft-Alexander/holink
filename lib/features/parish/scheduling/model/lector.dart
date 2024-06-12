class Lector {
  final int id;
  final String name;
  final String contactInfo;

  Lector({required this.id, required this.name, required this.contactInfo});

  factory Lector.fromMap(Map<String, dynamic> map) {
    return Lector(
      id: map['id'],
      name: map['name'],
      contactInfo: map['contact_info'],
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
