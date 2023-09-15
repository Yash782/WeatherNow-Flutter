import 'package:flutter/material.dart';

class AdditionalInfoItems extends StatelessWidget {
  final String infoType;
  final String infoVal;
  final IconData infoIcon;
  const AdditionalInfoItems({
    required this.infoIcon,
    required this.infoType,
    required this.infoVal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          infoIcon,
          size: 40,
        ),
        const SizedBox(height: 10),
        Text(
          infoType,
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 6),
        Text(
          infoVal,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
