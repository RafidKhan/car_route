import 'package:flutter/material.dart';

class GlobalTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final int? maxLines;
  final int? maxLength;
  final Function(String)? onChanged;

  const GlobalTextFormField({
    super.key,
    required this.textEditingController,
    this.hintText = '',
    this.onChanged,
    this.maxLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: textEditingController,
        onChanged: onChanged,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        decoration: InputDecoration(
          filled: true,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ));
  }
}
