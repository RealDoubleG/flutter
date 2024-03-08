class Equipment {
  int? id;
  String name;
  String description;

  Equipment({this.id, required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Equipment.fromMap(Map<String, dynamic> map) {
    return Equipment(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  @override
  String toString() {
    return 'Equipment{id: $id, name: $name, description: $description}';
  }
}
