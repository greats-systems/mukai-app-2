import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/group.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

class AdmingSettingsLandingScreen extends StatefulWidget {
  const AdmingSettingsLandingScreen({super.key});

  @override
  State<AdmingSettingsLandingScreen> createState() =>
      _AdmingSetttingsLandingScreenState();
}

class _AdmingSetttingsLandingScreenState
    extends State<AdmingSettingsLandingScreen> {
  late double height;
  late double width;
  final AuthController authController = AuthController();
  final GroupController groupController = GroupController();
  List<Profile>? profiles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Adjust the radius as needed
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 20.0,
        toolbarHeight: 70.0,
        title: Text(
          Utils.trimp('Admin Setting'),
          style: bold18WhiteF5,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: whiteF5Color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(0.0),
                ),
                border: Border.all(
                  color: whiteF5Color,
                ),
                // boxShadow: boxShadow,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(fixPadding * 2.0),
                children: [
                  //   groupDetails(),
                  // heightBox(20),
                  feedbackDetails()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  groupDetails() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(
          'Group Details',
          style: regular16Black,
        ),
      ),
      height5Space,
      Container(
        height: height * 0.35,
        width: width * 0.9,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: whiteF5Color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              blurRadius: 8.0, // Blur radius
              spreadRadius: 2.0, // Spread radius
              offset: const Offset(0, 4), // Shadow position (bottom)
            ),
          ],
        ),
        child: Column(
          spacing: 5,
          children: [
            Row(
              spacing: 10,
              children: [
                Iconify(
                  Ri.customer_service_2_line,
                  color: primaryColor,
                ),
                Text(
                  'Support',
                  style: bold16Black,
                )
              ],
            ),
            Divider(
              color: greyColor.withValues(alpha: 0.2),
            ),
            Row(
              spacing: 10,
              children: [
                Iconify(
                  Ri.qr_code_line,
                  color: primaryColor,
                ),
                Text(
                  'Generate QR Code',
                  style: bold16Black,
                )
              ],
            ),
            Divider(
              color: greyColor.withValues(alpha: 0.2),
            ),
            Row(
              spacing: 10,
              children: [
                Iconify(
                  Ri.bar_chart_2_line,
                  color: primaryColor,
                ),
                Text(
                  'Reports',
                  style: bold16Black,
                )
              ],
            ),
          ],
        ),
      )
    ]);
  }

  feedbackDetails() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: height * 0.28,
        width: width * 0.9,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: whiteF5Color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          spacing: 5,
          children: [
            Row(
              spacing: 10,
              children: [
                Iconify(
                  Ri.customer_service_2_line,
                  color: primaryColor,
                ),
                Text(
                  'Support',
                  style: bold16Black,
                )
              ],
            ),
            Divider(
              color: greyColor.withValues(alpha: 0.2),
            ),
            Row(
              spacing: 10,
              children: [
                Iconify(
                  Ri.terminal_box_line,
                  color: primaryColor,
                ),
                Text(
                  'Report a bug',
                  style: bold16Black,
                )
              ],
            ),
            Divider(
              color: greyColor.withValues(alpha: 0.2),
            ),
            GestureDetector(
              onTap: showRatingDialog,
              child: Row(
                spacing: 10,
                children: [
                  Iconify(
                    Ri.mail_send_line,
                    color: primaryColor,
                  ),
                  Text(
                    'Send feedback',
                    style: bold16Black,
                  )
                ],
              ),
            ),
            Divider(
              color: greyColor.withValues(alpha: 0.2),
            ),
            GestureDetector(
              onTap: () {
                logoutDialog();
              },
              child: Row(
                spacing: 10,
                children: [
                  Iconify(
                    Ri.logout_box_line,
                    color: primaryColor,
                  ),
                  Text(
                    'Logout',
                    style: bold16Black,
                  )
                ],
              ),
            )
          ],
        ),
      )
    ]);
  }

  void showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double rating = 0;
        TextEditingController feedbackController = TextEditingController();
        return AlertDialog(
          title: const Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How would you rate your experience?'),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Additional feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle feedback submission here
                Navigator.of(context).pop();
                Get.snackbar('Thank you!', 'Your feedback has been submitted.');
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
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
              Obx(() => authController.isLoading.value == true
                  ? const Text(
                      "Logging out...",
                      style: bold16Black,
                      textAlign: TextAlign.center,
                    )
                  : const Text(
                      "Are you sure you want to logout this account?",
                      style: bold16Black,
                      textAlign: TextAlign.center,
                    )),
              heightSpace,
              heightSpace,
              Obx(() => authController.isLoading.value
                  ? const Center(
                      child: LinearProgressIndicator(
                      minHeight: 1,
                      color: primaryColor,
                    ))
                  : Row(
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
