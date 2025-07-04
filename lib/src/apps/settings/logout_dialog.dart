import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/group.controller.dart';
import 'package:mukai/theme/theme.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
    late double height;
  late double width;
  final AuthController authController = AuthController();
  final GroupController groupController = GroupController();
  @override
  Widget build(BuildContext context) {
    return logoutDialog();
  }

  logoutDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: whiteF5Color,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(fixPadding * 2.0),
            children: [
              Container(
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: whiteColor.withOpacity(0.1),
                ),
                alignment: Alignment.center,
                child: const Iconify(
                  MaterialSymbols.logout,
                  color: redColor,
                ),
              ),
              heightSpace,
              heightSpace,
              Obx(() => authController.isLoading.value == true ? const  Text(
                "Logging out...",
                style: bold16Black,
                textAlign: TextAlign.center,
              ) :
              const Text(
                "Are you sure you want to logout this account?",
                style: bold16Black,
                textAlign: TextAlign.center,
              )
              ),
              heightSpace,
              heightSpace,

              Obx(() => authController.isLoading.value ? const Center(child: LinearProgressIndicator(minHeight: 1, color: primaryColor,)) :
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: tertiaryColor,
                          boxShadow: recShadow,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(fixPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: whiteColor.withOpacity(0.1),
                          ),
                          child: const Text(
                            "Cancel",
                            style: bold16Primary,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                  widthSpace,
                  widthSpace,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        authController.logout();
                      },
                      child: Container(
                            padding: const EdgeInsets.all(fixPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: primaryColor,
                              boxShadow: buttonShadow,
                            ),
                            child: const Text(
                                    "Logout",
                                    style: bold16White,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          )),
                    ),
                  
                ],
              ))
            ],
          ),
        );
      },
    );
  }
}