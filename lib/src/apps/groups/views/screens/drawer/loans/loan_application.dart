import 'package:flutter/material.dart';

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar(title: 'Loan Application'),
      body: Center(child: Text('Loan application')));
  }
}