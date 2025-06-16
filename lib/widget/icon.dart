import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return logoButton(context);
  }

  logoButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/bottomBar');
      },
      child: Container(
        height: 50.0,
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icon.png',
                  height: 50.0,
                  // width: 200,
                  // color: recColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
