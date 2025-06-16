import 'package:mukai/utils/constants/colors.dart';
import 'package:mukai/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class TFormDividerWidget extends StatelessWidget {
  const TFormDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Row(
      children: [
        Flexible(
            child: Divider(
                thickness: 1,
                indent: 3,
                color: Colors.grey.withOpacity(0.3),
                endIndent: 10)),
        Text(tOR,
            style: Theme.of(context).textTheme.bodyLarge!.apply(
                color: isDark
                    ? tWhiteColor.withOpacity(0.5)
                    : tDarkColor.withOpacity(0.5))),
        Flexible(
            child: Divider(
                thickness: 1,
                indent: 3,
                color: Colors.grey.withOpacity(0.3),
                endIndent: 10)),
      ],
    );
  }
}
