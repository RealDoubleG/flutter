import 'package:flutter/material.dart';
import 'package:text_copypaster/models/Equipment.dart';
import 'package:text_copypaster/widgets/customCard.dart';

class CardsContainer extends StatelessWidget {
  final List<Equipment> equipments;
  final void Function() onDeleteEquipment;

  const CardsContainer(
      {Key? key, required this.equipments, required this.onDeleteEquipment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.topCenter,
        child: Wrap(
          runSpacing: 14,
          spacing: 14,
          alignment: WrapAlignment.start,
          children: equipments
              .map((equipment) => CustomCard(
                    equipment: equipment,
                    onDeleteEquipment: onDeleteEquipment,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
