import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_copypaster/database/databaseHelper.dart';
import 'package:text_copypaster/models/service.dart';
import 'package:text_copypaster/themes/colors.dart';
import 'package:text_copypaster/widgets/modals/serviceRegister/editService.dart';
import 'package:text_copypaster/widgets/serviceCardHeader.dart';

class ServiceCard extends StatefulWidget {
  final Service service;
  final Function() onRemove;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.onRemove,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _expanded = false;
  bool _isHovered = false;

  void toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _showEditServiceModal(Service service) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditService(onEditService: widget.onRemove, service: service);
        });
  }

  void showCopiedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Texto copiado com sucesso!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> confirmDelete(int id) async {
    DatabaseHelper data = DatabaseHelper();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja excluir este serviço?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                await data.deleteServiceById(id);
                await widget.onRemove();
                _expanded = false;
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.secundaryColor(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            ServiceCardHeader(
              name: widget.service.name,
              expanded: _expanded,
              onTap: toggleExpanded,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _expanded
                  ? Container(
                      width: 580,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: widget.service.description));
                                  showCopiedMessage();
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onHover: (event) {
                                    setState(() {
                                      _isHovered = true;
                                    });
                                  },
                                  onExit: (_) {
                                    setState(() {
                                      _isHovered = false;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: _isHovered
                                                ? Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? ThemeColors
                                                        .primaryColorLight
                                                    : Colors.white
                                                : Colors.transparent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          widget.service.description,
                                          style: TextStyle(
                                            color: _isHovered
                                                ? Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? ThemeColors
                                                        .primaryColorLight
                                                    : Colors.white
                                                : Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? ThemeColors
                                                        .primaryColorDark
                                                    : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? ThemeColors.primaryColorLight
                                      : Colors.white,
                                ),
                                onPressed: () {
                                  _showEditServiceModal(widget.service);
                                },
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? ThemeColors.primaryColorLight
                                      : Colors.white,
                                ),
                                onPressed: () {
                                  confirmDelete(widget.service.id as int);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
