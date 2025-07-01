// Helper widget for consistent metric rows
import 'package:flutter/material.dart';
import 'package:mukai/theme/theme.dart';

class MetricRow extends StatelessWidget {
  final String title;
  final String zigValue;
  final String usdValue;
  final String icon;

  const MetricRow(
      {required this.title,
      required this.zigValue,
      required this.usdValue,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        // Container(
        //   alignment: Alignment.center,
        //   child: Image.asset(
        //     icon,
        //     height: 40,
        //     color: whiteF5Color,
        //   ),
        // ),
        Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: whiteColor.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Text(
                  '$zigValue',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                width5Space,
                Container(
                  color: whiteF5Color.withOpacity(0.5),
                  width: 1.5,
                  height: 20,
                ),
                width5Space,
                Text(
                  '$usdValue',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
