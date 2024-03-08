// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_copypaster/models/Equipment.dart';
import 'package:text_copypaster/themes/colors.dart';

class ServiceRegisterModalHeader extends StatelessWidget {
  final Equipment equipment;

  const ServiceRegisterModalHeader({Key? key, required this.equipment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        Container(
          alignment: Alignment.centerLeft,
          height: 75,
          width: 540,
          child: SingleChildScrollView(
            child: Text(
              equipment.name,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.light
                    ? ThemeColors.primaryColorLight
                    : Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 36,
          width: 36,
          child: PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: "Editar",
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("Editar equipamento"),
                  ),
                ),
                const PopupMenuItem(
                  value: "Excluir",
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Excluir equipamento"),
                  ),
                ),
              ];
            },
            onSelected: (String value) {
              switch (value) {
                case "Novo":
                  break;
                case "Editar":
                  break;
                case "Excluir":
                  break;
              }
            },
            color: AppColors.terciaryColor(context),
          ),
        ),
      ],
    );
  }
}
