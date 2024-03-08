import 'package:flutter/material.dart';
import 'package:text_copypaster/models/Equipment.dart';
import 'package:text_copypaster/widgets/customCard.dart';

class CardsContainer extends StatelessWidget {
  final List<Equipment> equipments;

  const CardsContainer({Key? key, required this.equipments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Equipments received: $equipments');

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
                  ))
              .toList(),
        ),
      ),
    );
  }
}
