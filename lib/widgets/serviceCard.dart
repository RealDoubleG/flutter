import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_copypaster/themes/colors.dart';
import 'package:text_copypaster/widgets/serviceCardHeader.dart';

class ServiceCard extends StatefulWidget {
  const ServiceCard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _expanded = false;

  void toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secundaryColor(context),
          borderRadius: BorderRadius.circular(29),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 8,
              blurRadius: 29,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: AnimatedContainer(
          padding: const EdgeInsets.all(10),
          duration: const Duration(milliseconds: 200),
          width: 450,
          height: _expanded
              ? 150
              : 70, // Ajuste a altura do container conforme necessário
          color: AppColors.secundaryColor(context),
          child: Column(
            children: [
              ServiceCardHeader(
                expanded: _expanded,
                onTap: toggleExpanded,
              ),
              if (_expanded)
                Expanded(
                  // Use Expanded ou Flexible aqui para permitir que o texto expanda
                  child: Container(
                    padding: const EdgeInsets.only(top: 8, left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            child: Text(
                              'Descrição de exemplo...',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.copy,
                                size: 18,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? ThemeColors.primaryColorLight
                                    : Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.delete,
                              size: 18,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? ThemeColors.primaryColorLight
                                  : Colors.white,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
