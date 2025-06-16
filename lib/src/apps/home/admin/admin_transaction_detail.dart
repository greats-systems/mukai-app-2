import 'package:flutter/material.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/constants.dart' as constants;

class AdminTransactionDetail extends StatelessWidget {
  final Transaction transaction;
  const AdminTransactionDetail({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width / 12.5;
    final height = size.width / 2.5;
    return Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
          elevation: 0,
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: whiteF5Color,
            ),
          ),
          centerTitle: false,
          titleSpacing: 20.0,
          toolbarHeight: 70.0,
          title: Text(
            Utils.trimp('Transaction Details'),
            style: bold18WhiteF5,
          ),
        ),
        body: Padding(
            padding: EdgeInsets.only(
                top: height, left: width, right: width, bottom: height),
            child: _buildTransactionDetail(transaction)));
  }

  Widget _buildTransactionDetail(Transaction transaction) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount Paid:'),
                Text('\$${transaction.amount?.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date of Payment:'),
                Text(constants.formatDate(transaction.createdAt!)),
              ],
            ),
            SizedBox(height: 8),            
          ],
        ),
      ),
    );
  }
}
