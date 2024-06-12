class Sacristan {
  final int id;
  final String name;
  final String contactInfo;

  Sacristan({required this.id, required this.name, required this.contactInfo});

  factory Sacristan.fromMap(Map<String, dynamic> map) {
    return Sacristan(
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
