import 'package:flutter/material.dart';
import 'package:mukai/components/app_bar.dart';

class ViewContributionsScreen extends StatefulWidget {
  const ViewContributionsScreen({super.key});

  @override
  State<ViewContributionsScreen> createState() => _ViewContributionsScreenState();
}

class _ViewContributionsScreenState extends State<ViewContributionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'View contributions'),
      body: Center(child: Text('View contributions')));
  }
}