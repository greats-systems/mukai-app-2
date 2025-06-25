import 'package:flutter/material.dart';
import 'package:mukai/components/app_bar.dart';

class LoanStatusScreen extends StatefulWidget {
  const LoanStatusScreen({super.key});

  @override
  State<LoanStatusScreen> createState() => _LoanStatusScreenState();
}

class _LoanStatusScreenState extends State<LoanStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Loan Status'),
      body: Center(child: Text('Loan status')));
  }
}