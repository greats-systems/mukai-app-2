import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mukai/src/apps/reports/widgets/bar_graph.dart';
import 'package:mukai/theme/theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<String> periodList = [
    'Weekly',
    'Monthly',
  ];
  List<double> weeklyDeposits = [
    22.87,
    11.23,
    18.18,
    36.28,
    20.84,
    27.07,
    12.93
  ];

  List<double> weeklyWithdrawals = [
    19.48,
    17.36,
    12.14,
    28.78,
    16.96,
    20.18,
    17.84
  ];

  List<double> monthlyDeposits = [
    12.87,
    44.41,
    52.11,
    35.67,
    65.21,
    77.20,
    45.34,
    29.35,
    48.36,
    12.85,
    66.33,
    81.20
  ];

  List<double> monthlyWithdrawals = [
    10.97,
    58.17,
    25.36,
    30.78,
    15.37,
    41.38,
    38.21,
    38.89,
    24.11,
    42.59,
    37.11,
    74.86
  ];
  String? selectedDropdownValue;

  void setDropdownValue(String value) {
    setState(() {
      selectedDropdownValue = value;
    });
    log(selectedDropdownValue!);
  }

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = 'Weekly';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    // return Center(child: const Text('Reports screen'));
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            top: height / 7.5,
            left: width / 20,
            right: width / 20,
            bottom: height / 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Total balance',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '\$10 164,75',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Overview',
                    style: TextStyle(fontSize: 36),
                  ),
                  DropdownButton<String>(
                    value: selectedDropdownValue ??
                        periodList[0], // Default selected value
                    items: periodList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDropdownValue(newValue!);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 45,
              ),
              MyBarGraph(
                periodicDeposits: selectedDropdownValue == 'Weekly'
                    ? weeklyDeposits
                    : monthlyDeposits,
                periodicWithdrawals: selectedDropdownValue == 'Weekly'
                    ? weeklyWithdrawals
                    : monthlyWithdrawals,
              ),
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(25)),
                    width: width / 2.5,
                    height: height / 6,
                    child: Center(
                        child: Text(
                      'Deposits\n\$12 300,89',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  SizedBox(
                    width: width / 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: recColor,
                        borderRadius: BorderRadius.circular(25)),
                    width: width / 2.5,
                    height: height / 6,
                    child: Center(
                        child: Text(
                      'Withdrawals\n\$3 289,20',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
