import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 1.0,
      color: blackOrignalColor.withOpacity(0.1),
    );
  }
}
