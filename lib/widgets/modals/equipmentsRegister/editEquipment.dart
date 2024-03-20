import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_copypaster/database/databaseHelper.dart';
import 'package:text_copypaster/models/Equipment.dart';
import 'package:text_copypaster/themes/colors.dart';

class EditEquipment extends StatelessWidget {
  final Function() onEditEquipment;
  final Equipment equipment;

  const EditEquipment(
      {Key? key, required this.onEditEquipment, required this.equipment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: equipment.name);
    TextEditingController descriptionController =
        TextEditingController(text: equipment.description);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildContent(context, nameController, descriptionController),
    );
  }

  Widget _buildContent(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController descriptionController) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 509,
        height: 320,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : ThemeColors.secundaryColorDark,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).brightness == Brightness.light
                          ? ThemeColors.primaryColorLight
                          : Colors.white,
                    ),
                  ),
                ),
                Text(
                  'Editar equipamento',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.light
                        ? ThemeColors.primaryColorLight
                        : Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Preencha o formulário abaixo',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                )),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Digite o nome do equipamento *',
                labelStyle: TextStyle(fontSize: 18),
                hintText: 'Digite o nome...',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Descrição do equipamento *',
                labelStyle: TextStyle(fontSize: 18),
                hintText: 'Digite o nome...',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () async {
                  String newName = nameController.text;
                  String newDescription = descriptionController.text;

                  if (newName.isNotEmpty && newDescription.isNotEmpty) {
                    // Atualize o equipamento com os novos valores
                    equipment.name = newName;
                    equipment.description = newDescription;

                    DatabaseHelper data = DatabaseHelper();
                    await data.editEquipmentById(equipment);

                    // Execute a função fornecida para atualizar a exibição
                    onEditEquipment();

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Erro'),
                        content:
                            const Text('Por favor, preencha todos os campos.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text(
                  'Editar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
