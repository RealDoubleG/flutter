import 'package:flutter/material.dart';
import 'package:text_copypaster/themes/colors.dart';

class ServiceCardHeader extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const ServiceCardHeader({
    Key? key,
    required this.expanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: Theme.of(context).iconTheme.copyWith(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  size: 48,
                ),
              ),
              const SizedBox(width: 8), // Add some space between icon and text
              Text(
                'Nome do serviço',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.light
                      ? ThemeColors.primaryColorLight
                      : Colors.white,
                ),
              )
            ],
          ),
          Theme(
            data: Theme.of(context).copyWith(
              iconTheme: Theme.of(context).iconTheme.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
            ),
            child: Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
