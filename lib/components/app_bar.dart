import 'package:flutter/material.dart';
import 'package:mukai/theme/theme.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0), // Adjust the radius as needed
            ),
          ),
          elevation: 0,
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: whiteF5Color,
            ),
          ),
          centerTitle: false,
          titleSpacing: 20.0,
          toolbarHeight: 70.0,
          title: SizedBox(
            child: Text(
              title,
              style: medium18WhiteF5,
            ),
          ),
        );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
