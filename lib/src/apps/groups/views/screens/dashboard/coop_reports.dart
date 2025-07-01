import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mukai/core/config/dio_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mukai/brick/models/financial_report.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/home/widgets/assets/pay_subs.dart';
import 'package:mukai/src/apps/reports/widgets/bar_graph.dart';
import 'package:mukai/src/controllers/financial_report.controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
// import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/widget/loading_shimmer.dart';
// import 'package:mukai/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class CoopReportsWidget extends StatefulWidget {
  final Group group;
  final String walletId;
  const CoopReportsWidget(
      {super.key, required this.walletId, required this.group});

  @override
  State<CoopReportsWidget> createState() => _CoopReportsWidgetState();
}

class _CoopReportsWidgetState extends State<CoopReportsWidget> {
  List<int> monthlyIndices = [];
  List<String> dailyLabels = [];
  List<String> weeklyLabels = [];
  List<String> monthlyLabels = [];

  final GetStorage getStorage = GetStorage();
  final FinancialReportController _financialReportController =
      FinancialReportController();
  final WalletController _walletController = WalletController();
  final List<Map<String, dynamic>> report = [];
  // final WalletController _groupWalletController = WalletController();
  String? userId;
  List<Wallet?>? wallets;
  Wallet? cooperativeUSDWallet;
  Wallet? individualZigWallet;
  List<FinancialReport>? financialReport;
  List<FinancialReport>? financialReportZIG_;

  final dio = DioClient().dio;
  bool _isLoading = true;
  bool _isDisposed = false;
  final _downloadController = CancelToken();
  final _dataController = CancelToken();

  @override
  void dispose() {
    _isDisposed = true;
    _downloadController.cancel(); // Cancel any ongoing downloads
    _dataController.cancel(); // Cancel any data fetching
    super.dispose();
  }

  // Modified to check mounted state before setState
  void safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }

  Future<void> _fetchFinancialReport() async {
    try {
      log('Fetching coop financial report for wallet: ${widget.walletId}');
      financialReport =
          await _financialReportController.getFinancialReport(widget.walletId);

      if (financialReport != null) {
        log('Fetched ${financialReport!.length} transactions');
        // Filter reports by currency
        financialReportZIG_ = financialReport!
            .where((report) => report.currency?.toLowerCase() == 'zig')
            .toList();
        financialReport = financialReport!
            .where((report) => report.currency?.toLowerCase() == 'usd')
            .toList();

        createUSDReport();
        createZIGReport();
      } else {
        log('Received null financial report');
      }
    } catch (e) {
      if (!_isDisposed) {
        log('CoopReports _fetchFinancialReport error: $e');
      }
    }
  }

  Future<void> _fetchData() async {
    try {
      userId = await getStorage.read('userId');
      wallets = await _walletController.getWalletsByProfileID(userId!);

      // Use safeSetState instead of direct setState
      if (wallets != null) {
        for (var wallet in wallets!) {
          if (wallet!.is_group_wallet! && wallet.default_currency == 'usd') {
            safeSetState(() {
              cooperativeUSDWallet = wallet;
            });
          } else if (wallet.is_group_wallet! &&
              wallet.default_currency == 'zig') {
            safeSetState(() {
              individualZigWallet = wallet;
            });
          }
        }
      }
    } catch (e, s) {
      log('Error fetching wallet data: $e $s');
    }
  }

  List<String> periodList = [
    'Daily',
    'Monthly',
  ];
  List<String> currencyList = ['ZIG', 'USD'];

  List<double> dailyDepositsUSD_ = [];
  List<double> dailyWithdrawalsUSD_ = [];
  List<double> dailyDepositsZIG_ = [];
  List<double> dailyWithdrawalsZIG_ = [];

  List<double> weeklyDepositsUSD_ = [];
  List<double> weeklyWithdrawalsUSD_ = [];
  List<double> weeklyDepositsZIG_ = [];
  List<double> weeklyWithdrawalsZIG_ = [];

  List<double> monthlyDepositsUSD_ = [];
  List<double> monthlyWithdrawalsUSD_ = [];
  List<double> monthlyDepositsZIG_ = [];
  List<double> monthlyWithdrawalsZIG_ = [];

  List<double> annualDepositsUSD_ = [];
  List<double> annualWithdrawalsUSD_ = [];
  List<double> annualDepositsZIG_ = [];
  List<double> annualWithdrawalsZIG_ = [];

  void createUSDReport() {
    // Clear previous data
    dailyDepositsUSD_.clear();
    dailyWithdrawalsUSD_.clear();
    weeklyDepositsUSD_.clear();
    weeklyWithdrawalsUSD_.clear();
    monthlyDepositsUSD_.clear();
    monthlyWithdrawalsUSD_.clear();

    dailyLabels.clear();
    weeklyLabels.clear();
    monthlyLabels.clear();

    if (financialReport != null) {
      final now = DateTime.now();

      // Initialize daily data (last 7 days)
      final dailyData = List.generate(7, (index) {
        final date = now.subtract(Duration(days: 6 - index));
        return _DailyData(
          day: date,
          credit: 0.0,
          debit: 0.0,
        );
      });

      // Initialize weekly data (last 8 weeks)
      final weeklyData = List.generate(8, (index) {
        final weekStart = now.subtract(Duration(days: (7 - index) * 7));
        return _WeeklyData(
          weekStart: weekStart,
          credit: 0.0,
          debit: 0.0,
        );
      });

      // Initialize monthly data (all 12 months)
      final year = now.year;
      final monthlyData = List.generate(12, (index) {
        return _MonthlyData(
          month: DateTime(year, index + 1),
          credit: 0.0,
          debit: 0.0,
        );
      });

      // Process USD transactions
      for (var report in financialReport!) {
        final amount = report.amount ?? 0;
        if (report.periodStart != null) {
          try {
            final dt = DateTime.parse(report.periodStart!);
            // Daily processing
            if (report.periodType == 'daily') {
              for (var daily in dailyData) {
                if (isSameDay(dt, daily.day)) {
                  if (report.narrative == 'credit') {
                    daily = daily.copyWith(credit: daily.credit + amount);
                  } else {
                    daily = daily.copyWith(debit: daily.debit + amount);
                  }
                  break;
                }
              }
            }
            // Weekly processing
            else if (report.periodType == 'weekly') {
              for (var weekly in weeklyData) {
                if (isSameWeek(dt, weekly.weekStart)) {
                  if (report.narrative == 'credit') {
                    weekly = weekly.copyWith(credit: weekly.credit + amount);
                  } else {
                    weekly = weekly.copyWith(debit: weekly.debit + amount);
                  }
                  break;
                }
              }
            }
            // Monthly processing
            else if (report.periodType == 'monthly') {
              final monthIndex = dt.month - 1;
              if (monthIndex >= 0 && monthIndex < 12) {
                if (report.narrative == 'credit') {
                  monthlyData[monthIndex] = monthlyData[monthIndex].copyWith(
                      credit: monthlyData[monthIndex].credit + amount);
                } else {
                  monthlyData[monthIndex] = monthlyData[monthIndex]
                      .copyWith(debit: monthlyData[monthIndex].debit + amount);
                }
              }
            }
          } catch (e) {
            log('Error processing USD transaction: $e');
          }
        }
      }

      // Populate daily data
      for (var daily in dailyData) {
        dailyDepositsUSD_.add(daily.credit);
        dailyWithdrawalsUSD_.add(daily.debit);
        dailyLabels.add(DateFormat('E').format(daily.day)); // Mon, Tue, etc.
      }
      log('dailyDepositsUSD_: $dailyDepositsUSD_');
      // Populate weekly data
      for (var weekly in weeklyData) {
        weeklyDepositsUSD_.add(weekly.credit);
        weeklyWithdrawalsUSD_.add(weekly.debit);
        weeklyLabels.add('W${DateFormat('d MMM').format(weekly.weekStart)}');
      }

      // Populate monthly data
      for (var monthData in monthlyData) {
        monthlyDepositsUSD_.add(monthData.credit);
        monthlyWithdrawalsUSD_.add(monthData.debit);
        monthlyLabels.add(DateFormat('MMM').format(monthData.month));
      }
    }
  }

  void createZIGReport() {
    // Clear previous data
    dailyDepositsZIG_.clear();
    dailyWithdrawalsZIG_.clear();
    weeklyDepositsZIG_.clear();
    weeklyWithdrawalsZIG_.clear();
    monthlyDepositsZIG_.clear();
    monthlyWithdrawalsZIG_.clear();

    dailyLabels.clear();
    weeklyLabels.clear();
    monthlyLabels.clear();

    if (financialReportZIG_ != null) {
      final now = DateTime.now();

      // Initialize daily data (last 7 days)
      final dailyData = List.generate(7, (index) {
        final date = now.subtract(Duration(days: 6 - index));
        return _DailyData(
          day: date,
          credit: 0.0,
          debit: 0.0,
        );
      });

      // Initialize weekly data (last 8 weeks)
      final weeklyData = List.generate(8, (index) {
        final weekStart = now.subtract(Duration(days: (7 - index) * 7));
        return _WeeklyData(
          weekStart: weekStart,
          credit: 0.0,
          debit: 0.0,
        );
      });

      // Initialize monthly data (all 12 months)
      final year = now.year;
      final monthlyData = List.generate(12, (index) {
        return _MonthlyData(
          month: DateTime(year, index + 1),
          credit: 0.0,
          debit: 0.0,
        );
      });

      // Process ZIG transactions
      for (var report in financialReportZIG_!) {
        final amount = report.amount ?? 0;
        if (report.periodStart != null) {
          try {
            final dt = DateTime.parse(report.periodStart!);
            // Daily processing
            if (report.periodType == 'daily') {
              for (var daily in dailyData) {
                if (isSameDay(dt, daily.day)) {
                  if (report.narrative == 'credit') {
                    daily = daily.copyWith(credit: daily.credit + amount);
                  } else {
                    daily = daily.copyWith(debit: daily.debit + amount);
                  }
                  break;
                }
              }
            }
            // Weekly processing
            else if (report.periodType == 'weekly') {
              for (var weekly in weeklyData) {
                if (isSameWeek(dt, weekly.weekStart)) {
                  if (report.narrative == 'credit') {
                    weekly = weekly.copyWith(credit: weekly.credit + amount);
                  } else {
                    weekly = weekly.copyWith(debit: weekly.debit + amount);
                  }
                  break;
                }
              }
            }
            // Monthly processing
            else if (report.periodType == 'monthly') {
              final monthIndex = dt.month - 1;
              if (monthIndex >= 0 && monthIndex < 12) {
                if (report.narrative == 'credit') {
                  monthlyData[monthIndex] = monthlyData[monthIndex].copyWith(
                      credit: monthlyData[monthIndex].credit + amount);
                } else {
                  monthlyData[monthIndex] = monthlyData[monthIndex]
                      .copyWith(debit: monthlyData[monthIndex].debit + amount);
                }
              }
            }
          } catch (e) {
            log('Error processing ZIG transaction: $e');
          }
        }
      }

      // Populate daily data
      for (var daily in dailyData) {
        dailyDepositsZIG_.add(daily.credit);
        dailyWithdrawalsZIG_.add(daily.debit);
        dailyLabels.add(DateFormat('E').format(daily.day)); // Mon, Tue, etc.
      }
      log('dailyDepositsZIG_: $dailyDepositsZIG_');

      // Populate weekly data
      for (var weekly in weeklyData) {
        weeklyDepositsZIG_.add(weekly.credit);
        weeklyWithdrawalsZIG_.add(weekly.debit);
        weeklyLabels.add('W${DateFormat('d MMM').format(weekly.weekStart)}');
      }
      log('weeklyDepositsZIG_: $weeklyDepositsZIG_');

      // Populate monthly data
      for (var monthData in monthlyData) {
        monthlyDepositsZIG_.add(monthData.credit);
        monthlyWithdrawalsZIG_.add(monthData.debit);
        monthlyLabels.add(DateFormat('MMM').format(monthData.month));
      }
      log('monthlyDepositsZIG_: $monthlyDepositsZIG_');
    }
  }

// Helper functions
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isSameWeek(DateTime a, DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return a.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        a.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  String? selectedDropdownValue;
  String? selectedCurrencyValue;
  bool isDownloading = false;

  Future<void> downloadReport() async {
    safeSetState(() => isDownloading = true);
    try {
      String fileContent = '';
      final currencySymbol = selectedCurrencyValue == 'USD' ? '\$' : 'ZIG';

      if (selectedDropdownValue == 'Daily') {
        fileContent = 'Daily Report ($selectedCurrencyValue)\n';
        fileContent += 'Date,Deposit,Withdrawal\n';
        for (int i = 0; i < dailyLabels.length; i++) {
          fileContent += '${dailyLabels[i]},'
              '${selectedCurrencyValue == 'USD' ? dailyDepositsUSD_[i] : dailyDepositsZIG_[i]}$currencySymbol,'
              '${selectedCurrencyValue == 'USD' ? dailyWithdrawalsUSD_[i] : dailyWithdrawalsZIG_[i]}$currencySymbol\n';
        }
      } else {
        fileContent = 'Monthly Report ($selectedCurrencyValue)\n';
        fileContent += 'Month,Deposit,Withdrawal\n';
        for (int i = 0; i < monthlyLabels.length; i++) {
          fileContent += '${monthlyLabels[i]},'
              '${selectedCurrencyValue == 'USD' ? monthlyDepositsUSD_[i] : monthlyDepositsZIG_[i]}$currencySymbol,'
              '${selectedCurrencyValue == 'USD' ? monthlyWithdrawalsUSD_[i] : monthlyWithdrawalsZIG_[i]}$currencySymbol\n';
        }
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}_$selectedCurrencyValue.csv');
      await file.writeAsString(fileContent);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('$selectedCurrencyValue report downloaded successfully!')),
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
  }

  void setDropdownValue(String value) {
    if (_isDisposed) return;
    setState(() {
      selectedDropdownValue = value;
      if (cooperativeUSDWallet != null) {
        _fetchFinancialReport().then((_) {
          createUSDReport();
          createZIGReport();
        });
      }
    });
    log(selectedDropdownValue!);
  }

  void setCurrencyValue(String value) {
    if (_isDisposed) return;
    setState(() {
      selectedCurrencyValue = value;
    });
    log(selectedCurrencyValue!);
  }

  Future<void> _initializeData() async {
    safeSetState(() => _isLoading = true);
    try {
      await _fetchData(); // First load wallets
      if (!_isDisposed) {
        await _fetchFinancialReport();
        if (!_isDisposed) {
          createUSDReport();
          createZIGReport();
        }
      }
    } catch (e) {
      if (!_isDisposed) {
        log('Initialization error: $e');
      }
    } finally {
      if (!_isDisposed) {
        safeSetState(() => _isLoading = false);
      }
    }
  }

  downloadReports(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // TODO: Implement download functionality
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Download Coperative Report'),
              content: Text('Choose download format'),
              actions: [
                TextButton(
                  onPressed: () {
                    downloadReport();
                    Helper.successSnackBar(
                        title: 'Success',
                        message: 'Report downloaded successfully',
                        duration: 5);
                    Navigator.pop(context);
                    // Download as PDF
                  },
                  child: Text('PDF'),
                ),
                TextButton(
                  onPressed: () {
                    downloadReport();
                    Helper.successSnackBar(
                        title: 'Success',
                        message: 'Report downloaded successfully',
                        duration: 5);
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
    );
  }

  @override
  void initState() {
    log('CoopReports wallet id: ${widget.walletId}');
    super.initState();
    log('Coop reports');
    _initializeData();
    selectedDropdownValue = 'Daily';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent column from expanding
          children: [
            // Header Row with controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                paySubscription(context),
                downloadReports(context),
              ],
            ),
            _buildControlsRow(size.width),
            _createGraph(),
          ],
        ),
      ),
    );
  }

  Widget _createGraph() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2, // Reduced from 0.5 to 0.35
      padding: const EdgeInsets.symmetric(
        vertical: 1,
      ),
      child: _isLoading
          ? const Center(child: LoadingShimmerWidget())
          : MyBarGraph(
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
    );
  }

  Widget paySubscription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // Get.to(() => TransferTransactionScreen(group: widget.group));
              Get.to(() => MemberPaySubs(group: widget.group));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: tertiaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    'Pay Subscription',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsRow(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // _buildDownloadButton(),
          _buildCurrencyDropdown(),
          _buildPeriodDropdown(),
        ],
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButton<String>(
      underline: const SizedBox(),
      dropdownColor: primaryColor.withAlpha(100),
      value: selectedCurrencyValue ?? currencyList[0],
      items: currencyList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() => selectedCurrencyValue = newValue);
      },
    );
  }

  Widget _buildPeriodDropdown() {
    return DropdownButton<String>(
      underline: const SizedBox(),
      dropdownColor: primaryColor.withAlpha(100),
      value: selectedDropdownValue ?? periodList[0],
      items: periodList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() => selectedDropdownValue = newValue);
      },
    );
  }
}

class _DailyData {
  final DateTime day;
  final double credit;
  final double debit;

  _DailyData({
    required this.day,
    required this.credit,
    required this.debit,
  });

  _DailyData copyWith({
    DateTime? day,
    double? credit,
    double? debit,
  }) {
    return _DailyData(
      day: day ?? this.day,
      credit: credit ?? this.credit,
      debit: debit ?? this.debit,
    );
  }
}

class _WeeklyData {
  final DateTime weekStart;
  final double credit;
  final double debit;

  _WeeklyData({
    required this.weekStart,
    required this.credit,
    required this.debit,
  });

  _WeeklyData copyWith({
    DateTime? weekStart,
    double? credit,
    double? debit,
  }) {
    return _WeeklyData(
      weekStart: weekStart ?? this.weekStart,
      credit: credit ?? this.credit,
      debit: debit ?? this.debit,
    );
  }
}

class _MonthlyData {
  final DateTime month;
  final double credit;
  final double debit;

  _MonthlyData({
    required this.month,
    required this.credit,
    required this.debit,
  });

  _MonthlyData copyWith({
    DateTime? month,
    double? credit,
    double? debit,
  }) {
    return _MonthlyData(
      month: month ?? this.month,
      credit: credit ?? this.credit,
      debit: debit ?? this.debit,
    );
  }
}
