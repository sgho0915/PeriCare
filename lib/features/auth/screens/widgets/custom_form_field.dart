import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final bool obscureText;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }
}
