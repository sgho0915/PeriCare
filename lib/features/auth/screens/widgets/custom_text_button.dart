import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSocial;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSocial = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSocial ? Colors.white : Colors.blue,
          foregroundColor: isSocial ? Colors.black : Colors.white,
          side: isSocial ? const BorderSide(color: Colors.grey) : BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
