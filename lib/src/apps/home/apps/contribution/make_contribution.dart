import 'package:flutter/material.dart';
import 'package:mukai/components/app_bar.dart';

class MakeContributionScreen extends StatefulWidget {
  const MakeContributionScreen({super.key});

  @override
  State<MakeContributionScreen> createState() => _MakeContributionScreenState();
}

class _MakeContributionScreenState extends State<MakeContributionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Make Contribution'),
      body: Center(child: Text('Make contribution')));
  }
}