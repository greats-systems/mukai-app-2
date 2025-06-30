import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/components/app_bar.dart';
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
        floatingActionButton: _getStorage.read('account_type') == 'coop-manager'
            ? FloatingActionButton(
                onPressed: () {
                  Get.to(() => AddContributionScreen(group: widget.group));
                },
                backgroundColor: primaryColor,
                tooltip: 'Add Portfolio',
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
        appBar: MyAppBar(title: 'Make Contribution'),
        body: Center(child: Text('Make contribution')));
  }
}
