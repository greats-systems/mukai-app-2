// Helper widget for consistent metric rows
import 'package:flutter/material.dart';
import 'package:mukai/theme/theme.dart';

class MetricRow extends StatelessWidget {
  final String title;
  final String value;
  final String icon;

  const MetricRow(
      {required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            icon,
            height: 40,
            color: whiteF5Color,
          ),
        ),
        Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: whiteColor.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
