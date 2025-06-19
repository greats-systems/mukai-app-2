import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/apps/reports/widgets/bar_graph.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
// import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
// import 'package:mukai/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class CoopReportsWidget extends StatefulWidget {
  const CoopReportsWidget({super.key});

  @override
  State<CoopReportsWidget> createState() => _CoopReportsWidgetState();
}

class _CoopReportsWidgetState extends State<CoopReportsWidget> {
  final GetStorage getStorage = GetStorage();
  final List<Map<String, dynamic>> report = [];
  // final WalletController _groupWalletController = WalletController();
  final TransactionController _transactionController = TransactionController();
  String? userId;
  dynamic walletIdUSD;
  dynamic walletIdZIG;
  dynamic financialReportUSD;
  dynamic financialReportZIG;

  Future<void> _fetchData() async {
    try {
      userId = await getStorage.read('userId');
      final responseUSD = await supabase
          .from('wallets')
          .select('id')
          .eq('profile_id', userId!)
          .eq('is_group_wallet', true)
          .eq('default_currency', 'usd');

      final responseZIG = await supabase
          .from('wallets')
          .select('id')
          .eq('profile_id', userId!)
          .eq('is_group_wallet', true)
          .eq('default_currency', 'zig');

      if (responseUSD.isEmpty && responseZIG.isEmpty) {
        log('No USD/ZIG group wallet found for user $userId');
        walletIdUSD = null;
        walletIdZIG = null;
        financialReportUSD = [];
        financialReportZIG = [];
        return;
      }

      if (responseUSD.isNotEmpty) {
        walletIdUSD = responseUSD.first; // Use first() instead of single()
        financialReportUSD =
            await _transactionController.getFinancialReport(walletIdUSD['id']);
        createUSDReport();
      } else {
        log('No USD wallet found');
        return;
      }

      if (responseZIG.isNotEmpty) {
        walletIdZIG = responseZIG.first;
        financialReportZIG =
            await _transactionController.getFinancialReport(walletIdZIG['id']);
        createZIGReport();
      } else {
        log('No ZiG wallet found');
        return;
      }
    } catch (e, s) {
      log('Error fetching wallet data: $e $s');
      walletIdUSD = null;
      walletIdZIG = null;
      financialReportUSD = [];
      financialReportZIG = [];
    }
  }

  List<String> periodList = [
    'Daily',
    'Monthly',
  ];
  List<String> currencyList = [
    'ZIG',
    'USD',
  ];

  List<double> dailyDeposits = [
    22.87,
    11.23,
    18.18,
    36.28,
    20.84,
    27.07,
    12.93
  ];

  List<double> dailyDepositsUSD_ = [];
  List<double> dailyWithdrawalsUSD_ = [];
  List<double> dailyDepositsZIG_ = [];
  List<double> dailyWithdrawalsZIG_ = [];

  List<double> monthlyDepositsUSD_ = [];
  List<double> monthlyWithdrawalsUSD_ = [];
  List<double> monthlyDepositsZIG_ = [];
  List<double> monthlyWithdrawalsZIG_ = [];

  List<double> annualDepositsUSD_ = [];
  List<double> annualWithdrawalsUSD_ = [];
  List<double> annualDepositsZIG_ = [];
  List<double> annualWithdrawalsZIG_ = [];

  void createUSDReport() {
    for (var period in financialReportUSD) {
      if (period['period_type'] == 'daily') {
        dailyDepositsUSD_.add(period['deposit_usd'].toDouble());
        dailyWithdrawalsUSD_.add(period['withdrawal_usd'].toDouble());
      } else if (period['period_type'] == 'monthly') {
        monthlyDepositsUSD_.add(period['deposit_usd'].toDouble());
        monthlyWithdrawalsUSD_.add(period['withdrawal_usd'].toDouble());
      }
    }
  }

  void createZIGReport() {
    for (var period in financialReportUSD) {
      if (period['period_type'] == 'daily') {
        dailyDepositsZIG_.add(period['deposit_zig'].toDouble());
        dailyWithdrawalsZIG_.add(period['withdrawal_zig'].toDouble());
      } else if (period['period_type'] == 'monthly') {
        monthlyDepositsZIG_.add(period['deposit_zig'].toDouble());
        monthlyWithdrawalsZIG_.add(period['withdrawal_zig'].toDouble());
      }
    }
  }

  List<double> dailyWithdrawals = [
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
      final response =
          await supabase.from('transactions').select().eq('wallet_id', userId);

      if (response.isEmpty) {
        throw Exception('No transactions found');
      }

      // final transactions = response as List<dynamic>;

      String fileContent = '';
      if (selectedDropdownValue == 'Daily') {
        fileContent = 'Daily Report\n';
        fileContent += 'Date,Deposit,Withdrawal\n';
        for (int i = 0; i < dailyDeposits.length; i++) {
          fileContent +=
              'Day ${i + 1},${dailyDeposits[i]},${dailyWithdrawals[i]}\n';
        }
      } else {
        fileContent = 'Monthly Report\n';
        fileContent += 'Month,Deposit,Withdrawal\n';
        for (int i = 0; i < monthlyDeposits.length; i++) {
          fileContent +=
              'Month ${i + 1},${monthlyDeposits[i]},${monthlyWithdrawals[i]}\n';
        }
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.${selectedCurrencyValue?.toLowerCase() ?? 'csv'}');
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
    log('Coop reports');
    _fetchData();
    selectedDropdownValue = 'Daily';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    // return Center(child: const Text('Reports screen'));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Implement download functionality
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Download Report'),
                        content: Text('Choose download format'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Download as PDF
                            },
                            child: Text('PDF'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Download as Excel
                            },
                            child: Text('Excel'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.download, color: Colors.black, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Download Report',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                DropdownButton<String>(
                  underline: SizedBox(),
                  dropdownColor: primaryColor.withValues(alpha: 100),
                  value: selectedCurrencyValue ??
                      currencyList[0], // Default selected value
                  items: currencyList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
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
                  items:
                      periodList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setDropdownValue(newValue!);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: width * 0.85,
              height: height * 0.2,
              child: SizedBox(
                width: width * 0.85,
                height: height * 0.2,
                child: MyBarGraph(
                  periodicDeposits: selectedDropdownValue == 'Daily'
                      ? (selectedCurrencyValue == 'USD'
                          ? dailyDepositsUSD_
                          : dailyDepositsZIG_)
                      : (selectedCurrencyValue == 'USD'
                          ? monthlyDepositsUSD_
                          : monthlyDepositsZIG_),
                  periodicWithdrawals: selectedDropdownValue == 'Daily'
                      ? (selectedCurrencyValue == 'USD'
                          ? dailyWithdrawalsUSD_
                          : dailyWithdrawalsZIG_)
                      : (selectedCurrencyValue == 'USD'
                          ? monthlyWithdrawalsUSD_
                          : monthlyWithdrawalsZIG_),
                ),
                /*
              child: MyBarGraph(
                periodicDeposits: selectedDropdownValue == 'Daily'
                    ? dailyDeposits
                    : dailyWithdrawals,
                periodicWithdrawals: selectedDropdownValue == 'Monthly'
                    ? monthlyDeposits
                    : monthlyWithdrawals,
              ),
            ),           */
              ),
            ),
          ],
        ),
      ),
    );
  }
}
