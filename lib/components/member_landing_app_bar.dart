import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/src/apps/home/wallet_balances.dart';
import 'package:mukai/src/apps/home/widgets/app_header.dart';
import 'package:mukai/theme/theme.dart';

class MemberLandingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RxBool observedVariable; // Changed to RxBool for reactivity
  final Widget widgetIfTrue;
  final Widget widgetIfFalse;
  
  const MemberLandingAppBar({
    super.key,
    required this.observedVariable,
    required this.widgetIfTrue,
    required this.widgetIfFalse,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(336.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
          backgroundColor: whiteColor,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: -1.0,
          toolbarHeight: 340.0,
          elevation: 0,
          title: Column(
            children: [
              const AppHeaderWidget(),
              const WalletBalancesWidget(),
              heightBox(30),
              Obx(() => observedVariable.value ? widgetIfTrue : widgetIfFalse),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(336.0); // Fixed height
}