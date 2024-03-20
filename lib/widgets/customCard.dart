import 'package:flutter/material.dart';
import 'package:text_copypaster/models/Equipment.dart';
import 'package:text_copypaster/widgets/modals/serviceRegister/serviceRegisterModal.dart';

class CustomCard extends StatelessWidget {
  final Equipment equipment;
  final void Function() onDeleteEquipment;

  const CustomCard(
      {Key? key, required this.equipment, required this.onDeleteEquipment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showServiceRegisterModal(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        width: 350,
        height: 50,
        child: Center(
          child: Text(
            equipment.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  void _showServiceRegisterModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ServiceRegisterModal(
            equipment: equipment, onDeleteEquipment: onDeleteEquipment);
      },
    );
  }
}
