import 'package:flutter/material.dart';
import 'package:text_copypaster/themes/colors.dart';
import 'package:text_copypaster/widgets/textInput.dart';

class HeaderForm extends StatelessWidget {
  final VoidCallback onPressed;

  const HeaderForm({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      height: 90,
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.inputBorder()),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomTextField(
            hintText: 'Pesquisar...',
            prefixIcon: Icons.search,
            backgroundColor: AppColors.terciaryColor(context),
            width: 300,
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 45),
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'Novo Equipamento',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
