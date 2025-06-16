import 'package:auto_size_text/auto_size_text.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/icon.dart';
import 'package:flutter/material.dart';

class IconTitleHeaderWidget extends StatelessWidget {
  String? title;
  IconTitleHeaderWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const IconWidget(),
        width20Space,
        SizedBox(
          width: 200,
          child: AutoSizeText(
            textAlign: TextAlign.center,
            maxFontSize: 22,
            maxLines: 2,
            title!,
            style: const TextStyle(color: blackOrignalColor),
          ),
        ),
      ],
    );
  }
}
