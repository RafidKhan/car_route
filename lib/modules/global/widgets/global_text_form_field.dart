import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final int? maxLines;
  final int? maxLength;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;

  const GlobalTextFormField({
    super.key,
    required this.textEditingController,
    this.hintText = '',
    this.onChanged,
    this.maxLines,
    this.maxLength,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: textEditingController,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        decoration: InputDecoration(
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
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
