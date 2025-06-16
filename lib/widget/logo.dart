import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return logoButton(context);
  }

  logoButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profile');
      },
      child: Container(
        height: 50.0,
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 50.0,
                  // width: 200,
                  color: recColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
