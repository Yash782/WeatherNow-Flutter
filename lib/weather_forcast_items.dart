import 'package:flutter/material.dart';

class HourlyForcast extends StatelessWidget {
  final String time;
  final String tempreture;
  final IconData icon;
  const HourlyForcast(
      {super.key,
      required this.time,
      required this.tempreture,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Icon(icon, size: 40),
            const SizedBox(height: 6),
            Text(
              tempreture,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
