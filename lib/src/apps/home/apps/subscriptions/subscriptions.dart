import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/components/app_bar.dart';
import 'package:mukai/src/apps/home/widgets/assets/pay_subs.dart';
import 'package:mukai/theme/theme.dart';

class MySubscriptionsScreen extends StatefulWidget {
  final Group group;
  const MySubscriptionsScreen({super.key, required this.group});

  @override
  State<MySubscriptionsScreen> createState() => _MySubscriptionsScreenState();
}

class _MySubscriptionsScreenState extends State<MySubscriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => MemberPaySubs(group: widget.group));

          },
          backgroundColor: primaryColor,
          tooltip: 'Add Portfolio',
          child: const Icon(Icons.add, color: Colors.white),
        ),
        appBar: MyAppBar(title: 'My Subscriptions'),
        body: Center(child: Text('My subscriptions')));
  }
}
