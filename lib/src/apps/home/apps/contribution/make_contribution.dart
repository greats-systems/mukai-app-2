import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/components/app_bar.dart';
import 'package:mukai/src/apps/home/admin/account_transactions.dart';
import 'package:mukai/src/apps/home/admin/admin_recent_transactions.dart';
import 'package:mukai/src/apps/home/apps/contribution/add_contribution.dart';
import 'package:mukai/theme/theme.dart';

class MakeContributionScreen extends StatefulWidget {
  Group group;
  MakeContributionScreen({super.key, required this.group});

  @override
  State<MakeContributionScreen> createState() => _MakeContributionScreenState();
}

class _MakeContributionScreenState extends State<MakeContributionScreen> {
  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => AddContributionScreen(group: widget.group));
          },
          backgroundColor: primaryColor,
          tooltip: 'Add Portfolio',
          child: const Icon(Icons.add, color: Colors.white),
        ),
        appBar: MyAppBar(title: 'My Contributions'),
        body: Container(
            color: whiteF5Color,
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.8,
              child: AccountTransactionsList(),
            )));
  }
}
