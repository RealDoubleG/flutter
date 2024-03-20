class Service {
  int? id;
  String name;
  String description;
  int equipmentId;

  Service(
      {this.id,
      required this.name,
      required this.description,
      required this.equipmentId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'equipment_id': equipmentId
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      equipmentId: map['equipment_id'],
    );
  }
}
