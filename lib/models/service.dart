class Service {
  int id;
  String name;
  String description;

  Service({required this.id, required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
