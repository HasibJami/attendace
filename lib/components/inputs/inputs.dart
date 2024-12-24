import 'package:flutter/material.dart';
import 'package:sorkhposhan/constants/constants.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final TextAlign textAlign;

  const InputField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: deepBlue),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: custeomeGray),
          borderRadius: BorderRadius.circular(12),
        ),
        label: Align(
          alignment: Alignment.centerRight,
          child: Text(hintText),
        ),
      ),
      textAlign: textAlign,
      keyboardType: keyboardType,
    );
  }
}
