import 'package:text_copypaster/models/Equipment.dart';
import 'package:text_copypaster/models/service.dart';

class EquipmentService {
  Equipment equipment;
  List<Service> services;

  EquipmentService({required this.equipment, required this.services});

  Map<String, dynamic> toMap() {
    return {
      'equipmentId': equipment.id,
      'services': services.map((service) => service.toMap()).toList(),
    };
  }

  factory EquipmentService.fromMap(Map<String, dynamic> map) {
    return EquipmentService(
      equipment: Equipment(
        id: map['equipmentId'],
        name: map['name'],
        description: map['description'],
      ),
      services: List<Service>.from(
          map['services'].map((service) => Service.fromMap(service))),
    );
  }
}
