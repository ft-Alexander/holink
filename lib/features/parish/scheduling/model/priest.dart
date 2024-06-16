class Priest {
  final int id;
  final String name;
  final String contactInfo;

  Priest({required this.id, required this.name, required this.contactInfo});

  factory Priest.fromMap(Map<String, dynamic> map) {
    return Priest(
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
