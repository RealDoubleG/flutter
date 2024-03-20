import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_copypaster/database/databaseHelper.dart';
import 'package:text_copypaster/models/Equipment.dart';
import 'package:text_copypaster/models/service.dart';
import 'package:text_copypaster/themes/colors.dart';
import 'package:text_copypaster/widgets/modals/equipmentsRegister/editEquipment.dart';
import 'package:text_copypaster/widgets/modals/serviceRegister/editService.dart';
import 'package:text_copypaster/widgets/modals/serviceRegister/newService.dart';
import 'package:text_copypaster/widgets/serviceCard.dart';

class ServiceRegisterModal extends StatefulWidget {
  final Equipment equipment;
  final void Function() onDeleteEquipment;

  const ServiceRegisterModal(
      {Key? key, required this.equipment, required this.onDeleteEquipment})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ServiceRegisterModalState createState() => _ServiceRegisterModalState();
}

class _ServiceRegisterModalState extends State<ServiceRegisterModal> {
  List<Service> services = [];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    List<Service> loadedServices = await DatabaseHelper()
        .getServicesByEquipmentId(widget.equipment.id as int);
    setState(() {
      services = loadedServices;
    });
  }

  void _showEditEquipmentModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditEquipment(
          onEditEquipment: widget.onDeleteEquipment,
          equipment: widget.equipment,
        );
      },
    );
  }

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
    return SingleChildScrollView(
      child: Container(
        width: 650,
        height: 700,
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
                      widget.equipment.name,
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
                        const PopupMenuItem(
                            value: "Novo",
                            child: ListTile(
                              leading: Icon(Icons.add),
                              title: Text("Novo serviço"),
                            ))
                      ];
                    },
                    onSelected: (String value) async {
                      switch (value) {
                        case "Novo":
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NewServiceModal(
                                id: widget.equipment.id as int,
                                onServiceAdded: () {
                                  _loadServices();
                                },
                              );
                            },
                          );
                          break;
                        case "Editar":
                          _showEditEquipmentModal();
                          break;
                        case "Excluir":
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmar exclusão"),
                                content: const Text(
                                    "Tem certeza que deseja excluir este equipamento?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Fechar o diálogo
                                    },
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await DatabaseHelper()
                                          .deleteEquipmentByid(
                                              widget.equipment.id as int);
                                      widget.onDeleteEquipment();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Confirmar"),
                                  ),
                                ],
                              );
                            },
                          );
                          break;
                      }
                    },
                    color: AppColors.terciaryColor(context),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 570,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: services.map((service) {
                    return ServiceCard(
                      onRemove: _loadServices,
                      service: service,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
