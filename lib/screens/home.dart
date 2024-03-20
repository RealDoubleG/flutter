import 'package:flutter/material.dart';
import 'package:text_copypaster/database/databaseHelper.dart';
import 'package:text_copypaster/models/Equipment.dart';
import 'package:text_copypaster/themes/colors.dart';
import 'package:text_copypaster/widgets/cardsListing.dart';
import 'package:text_copypaster/widgets/headerForm.dart';
import 'package:text_copypaster/widgets/modals/equipmentsRegister/equipmentsRegisterModal.dart';

class Home extends StatefulWidget {
  final VoidCallback toggleTheme;

  const Home({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Equipment> equipments = [];

  @override
  void initState() {
    super.initState();
    _reloadEquipments();
  }

  Future<void> _reloadEquipments() async {
    List<Equipment> updatedEquipments =
        await DatabaseHelper().getAllEquipments();
    setState(() {
      equipments = updatedEquipments;
    });
  }

  Future<void> _searchEquipments(String query) async {
    if (!query.isEmpty) {
      List<Equipment> updatedEquipments =
          await DatabaseHelper().getEquipmentsByName(query);

      setState(() {
        equipments = updatedEquipments;
      });
    } else {
      List<Equipment> updatedEquipments =
          await DatabaseHelper().getAllEquipments();

      setState(() {
        equipments = updatedEquipments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Text('OS Text - Copypaster'),
        ),
        titleSpacing: 0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        backgroundColor: AppColors.primaryColor(context),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.terciaryColor(context),
              ),
              child: IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: () async {
                    try {
                      DatabaseHelper db = DatabaseHelper();
                      await db.importDatabase();
                      _reloadEquipments();
                    } catch (e) {
                      print('Erro ao importar banco de dados: $e');
                    }
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.terciaryColor(context),
              ),
              child: IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: () async {
                    try {
                      DatabaseHelper db = DatabaseHelper();
                      await db.exportDatabase();
                    } catch (e) {
                      print('Erro ao importar banco de dados: $e');
                    }
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.terciaryColor(context),
              ),
              child: IconButton(
                icon: const Icon(Icons.brightness_6),
                onPressed: widget.toggleTheme,
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
        color: AppColors.secundaryColor(context),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              'Meus equipamentos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            HeaderForm(
                onTextChanged: _searchEquipments,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                        child: EquipmentsRegisterModal(
                          onEquipmentAdded: () {
                            _reloadEquipments();
                          },
                        ),
                      );
                    },
                  );
                }),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.inputBorder()),
              ),
              child: CardsContainer(
                equipments: equipments,
                onDeleteEquipment: _reloadEquipments,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
