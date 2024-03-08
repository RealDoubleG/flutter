import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Color backgroundColor;
  final double width;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    this.backgroundColor = Colors.grey,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(prefixIcon),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15.0),
          ),
        ),
      ),
    );
  }
}
