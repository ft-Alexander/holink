class Sacristan {
  final int id;
  final String name;
  final String contactInfo;

  Sacristan({required this.id, required this.name, required this.contactInfo});

  factory Sacristan.fromJson(Map<String, dynamic> json) {
    return Sacristan(
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
