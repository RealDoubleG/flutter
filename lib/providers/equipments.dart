import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:text_copypaster/models/Equipment.dart';

class EquipmentsRepository extends ChangeNotifier {
  List<Equipment> _equipments = [];

  UnmodifiableListView<Equipment> get allEquipments =>
      UnmodifiableListView(_equipments);

  void reloadEquipments(List<Equipment> equipments) async {
    _equipments = equipments;
    notifyListeners();
  }
}
