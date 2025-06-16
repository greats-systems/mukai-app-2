import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
// import 'package:mukai/src/apps/groups/views/screens/group_members.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

class MemberSettingsLandingScreen extends StatefulWidget {
  const MemberSettingsLandingScreen({super.key});

  @override
  State<MemberSettingsLandingScreen> createState() =>
      _MemberSetttingsLandingScreenState();
}

class _MemberSetttingsLandingScreenState
    extends State<MemberSettingsLandingScreen> {
  late double height;
  late double width;
  final AuthController authController = AuthController();

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
          Utils.trimp('Member Settings'),
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
                boxShadow: boxShadow,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(fixPadding * 2.0),
                children: [groupDetails(), heightBox(20), feedbackDetails()],
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
        height: height * 0.29,
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
            /*
            GestureDetector(
              onTap: () {
                Get.to(() => GroupMembersScreen(
                      initialselectedTab: 0,
                    ));
              },
              child: Row(
                spacing: 10,
                children: [
                  Iconify(
                    Ri.account_circle_fill,
                    color: primaryColor,
                  ),
                  Text(
                    'Group Memebers',
                    style: bold16Black,
                  )
                ],
              ),
            ),
            Divider(
              color: greyColor.withValues(alpha: 0.2),
            ),
            Row(
              spacing: 10,
              children: [
                Iconify(
                  Ri.history_line,
                  color: primaryColor,
                ),
                Text(
                  'Group history',
                  style: bold16Black,
                )
              ],
            ),
            Divider(
              color: greyColor.withValues(alpha: 0.2),
            ),
            */
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
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(
          'Feedback',
          style: regular16Black,
        ),
      ),
      height5Space,
      Container(
        height: height * 0.18,
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
            Row(
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
            Divider(
              color: greyColor.withValues(alpha: 0.2),
            ),
            GestureDetector(
              onTap: authController.logout,
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
}
