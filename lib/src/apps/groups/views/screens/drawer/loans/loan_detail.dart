import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/components/app_bar.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

class LoanDetailScreen extends StatefulWidget {
  final Loan loan;
  final String? status;
  final Group? group;

  const LoanDetailScreen({
    super.key,
    required this.loan,
    this.status,
    this.group,
  });

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  TextEditingController purposeController = TextEditingController();
  TextEditingController collateralDescriptionController =
      TextEditingController();
  TextEditingController paybackPeriodController = TextEditingController();
  TextEditingController principalAmountController = TextEditingController();
  TextEditingController repaymentAmountController = TextEditingController();

  @override
  void initState() {
    log('LoanDetailScreen loan: ${JsonEncoder.withIndent('').convert(widget.loan.loanTermMonths)}');
    super.initState();
    // Initialize controllers with loan data
    purposeController.text = widget.loan.loanPurpose ?? '';
    collateralDescriptionController.text =
        widget.loan.collateralDescription ?? '';
    paybackPeriodController.text = widget.loan.loanTermMonths?.toString() ?? '';
    principalAmountController.text =
        widget.loan.principalAmount?.toStringAsFixed(2) ?? '';
    repaymentAmountController.text =
        widget.loan.paymentAmount?.toStringAsFixed(2) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.trimp(widget.loan.loanPurpose ?? 'Loan Details'),
              style: semibold18WhiteF5,
            ),
            Text(
              "Loan ID: ${widget.loan.id?.substring(28, 36) ?? ''}",
              style: semibold14WhiteF5,
            ),
          ],
        ),
      ),
      body: Container(
        color: whiteF5Color,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildDetailField(
              label: 'Purpose',
              value: purposeController.text,
            ),
            const SizedBox(height: 16),
            _buildDetailField(
              label: 'Principal Amount',
              value: '\$${principalAmountController.text}',
            ),
            const SizedBox(height: 16),
            _buildDetailField(
              label: 'Payback Period (months)',
              value: paybackPeriodController.text,
            ),
            const SizedBox(height: 16),
            _buildDetailField(
              label: 'Total Repayment Amount',
              value: '\$${repaymentAmountController.text}',
            ),
            if (widget.loan.collateralDescription?.isNotEmpty ?? false) ...[
              const SizedBox(height: 16),
              _buildDetailField(
                label: 'Collateral Description',
                value: collateralDescriptionController.text,
              ),
            ],
            const SizedBox(height: 24),
            Text(
              '* Calculated at 2% monthly compound interest',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: semibold14Black,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Text(
            value.isNotEmpty ? value : 'Not specified',
            style: TextStyle(color: greyB5Color),
          ),
        ),
      ],
    );
  }
}
