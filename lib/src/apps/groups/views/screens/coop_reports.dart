import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/apps/reports/widgets/bar_graph.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class CoopReportsWidget extends StatefulWidget {
  const CoopReportsWidget({super.key});

  @override
  State<CoopReportsWidget> createState() => _CoopReportsWidgetState();
}

class _CoopReportsWidgetState extends State<CoopReportsWidget> {
    final GetStorage getStorage = GetStorage();

  List<String> periodList = [
    'Weekly',
    'Monthly',
  ];
    List<String> currencyList = [
    'ZIG',
    'USD',
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
  String? selectedCurrencyValue;
  bool isDownloading = false;
  Future<void> downloadReport() async {
    // TODO: Implement download functionality
    try {
      final userId = getStorage.read('userId');
      final response = await supabase
          .from('transactions')
          .select()
          .eq('wallet_id', userId);

      if (response.isEmpty) {
        throw Exception('No transactions found');
      }

      final transactions = response as List<dynamic>;
      
      String fileContent = '';
      if (selectedDropdownValue == 'Weekly') {
        fileContent = 'Weekly Report\n';
        fileContent += 'Date,Deposit,Withdrawal\n';
        for (int i = 0; i < weeklyDeposits.length; i++) {
          fileContent += 'Day ${i + 1},${weeklyDeposits[i]},${weeklyWithdrawals[i]}\n';
        }
      } else {
        fileContent = 'Monthly Report\n';
        fileContent += 'Month,Deposit,Withdrawal\n';
        for (int i = 0; i < monthlyDeposits.length; i++) {
          fileContent += 'Month ${i + 1},${monthlyDeposits[i]},${monthlyWithdrawals[i]}\n';
        }
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.${selectedCurrencyValue?.toLowerCase() ?? 'csv'}');
      await file.writeAsString(fileContent);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report downloaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download report: $e')),
      );
    } finally {
      setState(() {
        isDownloading = false;
      });
    }

    setState(() {
      isDownloading = true;
    });
  }
  void setDropdownValue(String value) {
    setState(() {
      selectedDropdownValue = value;
    });
    log(selectedDropdownValue!);
  }

  void setCurrencyValue(String value) {
    setState(() {
      selectedCurrencyValue = value;
    });
    log(selectedCurrencyValue!);
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
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [

              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                                     DropdownButton<String>(
                    underline: SizedBox(),
                    dropdownColor: primaryColor.withValues(alpha: 100),
                    value: selectedCurrencyValue ??
                        currencyList[0], // Default selected value
                    items: currencyList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.black),),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setCurrencyValue(newValue!);
                    },
                  ),
                  DropdownButton<String>(
                    underline: SizedBox(),
                    dropdownColor: primaryColor.withValues(alpha: 100),
                    value: selectedDropdownValue ??
                        periodList[0], // Default selected value
                    items: periodList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.black),),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDropdownValue(newValue!);
                    },
                  ),
                ],
              ),
              SizedBox(
                width: width*0.85,
                height: height*0.25,
                child: MyBarGraph(
                  periodicDeposits: selectedDropdownValue == 'Weekly'
                      ? weeklyDeposits
                      : monthlyDeposits,
                  periodicWithdrawals: selectedDropdownValue == 'Weekly'
                      ? weeklyWithdrawals
                      : monthlyWithdrawals,
                ),
              ),


            ],
          ),
        ),
      );
  }
}
