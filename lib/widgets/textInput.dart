import 'dart:async';

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final Color backgroundColor;
  final double width;
  final Function(String) onTextChanged;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    this.backgroundColor = Colors.grey,
    required this.width,
    required this.onTextChanged,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 45,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(widget.prefixIcon),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15.0),
          ),
          onChanged: (text) {
            if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
            _debounceTimer = Timer(const Duration(milliseconds: 500), () {
              widget.onTextChanged(text);
            });
          },
        ),
      ),
    );
  }
}
