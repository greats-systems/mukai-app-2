import 'package:flutter/material.dart';
import 'package:mukai/src/apps/home/widgets/admin_app_header.dart';

class MukaiAdminLandingAppBar extends StatelessWidget implements PreferredSizeWidget{
  const MukaiAdminLandingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(105.0), // Match the toolbarHeight
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                blurRadius: 8.0, // Blur radius
                spreadRadius: 2.0, // Spread radius
                offset: const Offset(0, 4), // Shadow position (bottom)
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: 0.0,
            toolbarHeight: 100.0,
            elevation: 0,
            title: const AdminAppHeaderWidget(),
          ),
        ),
      );
  }

   @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}