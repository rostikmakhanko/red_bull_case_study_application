import 'package:flutter/material.dart';

class LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool darkBackground;

  const LabelValue({super.key, required this.label, required this.value, required this.darkBackground});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: darkBackground ? Colors.white70 : Colors.black54,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: darkBackground ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}