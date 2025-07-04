import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mukai/brick/models/financial_report.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/apps/home/widgets/app_header.dart';
import 'package:mukai/src/apps/reports/widgets/bar_graph.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/financial_report.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
// import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/widget/loading_shimmer.dart';
// import 'package:mukai/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<int> monthlyIndices = [];
  List<String> dailyLabels = [];
  List<String> weeklyLabels = [];
  List<String> monthlyLabels = [];

  final GetStorage getStorage = GetStorage();
  final FinancialReportController _financialReportController =
      FinancialReportController();
  final WalletController _walletController = WalletController();
  final List<Map<String, dynamic>> report = [];

  String? userId;
  List<Wallet?>? wallets;
  Wallet? individualUSDWallet;
  Wallet? individualZigWallet;
  List<FinancialReport>? financialReport;

  final dio = Dio();
  bool _isLoading = true;
  bool _isDisposed = false;
  final _downloadController = CancelToken();
  final _dataController = CancelToken();

  final AuthController authController = Get.find<AuthController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final WalletController walletController = Get.put(WalletController());
  final ProfileController profileController = Get.find<ProfileController>();

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
      if (individualUSDWallet == null) {
        log('No USD wallet available');
        return;
      }

      log('Fetching financial report for wallet: ${individualUSDWallet!.id}');
      financialReport = await _financialReportController
          .getFinancialReport(individualUSDWallet!.id!);

      if (financialReport != null) {
        log('Fetched ${financialReport!.length} transactions');
        // log(JsonEncoder.withIndent(' ').convert(financialReport));
        createUSDReport();
        createZIGReport();
      } else {
        log('Received null financial report');
      }
    } catch (e) {
      if (!_isDisposed) {
        log('ReportsScreen _fetchFinancialReport error: $e');
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
          if (!wallet!.is_group_wallet! && wallet.default_currency == 'usd') {
            safeSetState(() {
              individualUSDWallet = wallet;
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
  List<String> currencyList = [
    'ZIG',
    'USD',
  ];

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

      // Process transactions
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
            log('Error processing transaction: $e');
          }
        }
      }

      // Populate daily data
      for (var daily in dailyData) {
        dailyDepositsUSD_.add(daily.credit);
        dailyWithdrawalsUSD_.add(daily.debit);
        dailyLabels.add(DateFormat('E').format(daily.day)); // Mon, Tue, etc.
      }

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

      // Process transactions
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
            log('Error processing transaction: $e');
          }
        }
      }

      // Populate daily data
      for (var daily in dailyData) {
        dailyDepositsUSD_.add(daily.credit);
        dailyWithdrawalsUSD_.add(daily.debit);
        dailyLabels.add(DateFormat('E').format(daily.day)); // Mon, Tue, etc.
      }

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
    // TODO: Implement download functionality
    safeSetState(() => isDownloading = true);
    try {
      // final transactions = response as List<dynamic>;

      String fileContent = '';
      if (selectedDropdownValue == 'Daily') {
        fileContent = 'Daily Report\n';
        fileContent += 'Date,Deposit,Withdrawal\n';
        for (int i = 0; i < dailyDepositsUSD_.length; i++) {
          fileContent +=
              'Day ${i + 1},${dailyDepositsUSD_[i]},${dailyWithdrawalsUSD_[i]}\n';
        }
      } else {
        fileContent = 'Monthly Report\n';
        fileContent += 'Month,Deposit,Withdrawal\n';
        for (int i = 0; i < monthlyDepositsUSD_.length; i++) {
          fileContent +=
              'Month ${i + 1},${monthlyDepositsUSD_[i]},${monthlyWithdrawalsUSD_[i]}\n';
        }
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.${selectedCurrencyValue?.toLowerCase() ?? 'csv'}');
      await file.writeAsString(fileContent);
      Helper.successSnackBar(
          title: 'Download success',
          message: 'Report downloaded successfully',
          duration: 5);
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
    if (_isDisposed) return;
    setState(() {
      selectedDropdownValue = value;
      if (individualUSDWallet != null) {
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
      if (!_isDisposed && individualUSDWallet != null) {
        await _fetchFinancialReport();
        if (!_isDisposed) {
          createUSDReport();
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

  @override
  void initState() {
    super.initState();
    log('Member reports');
    _initializeData();
    selectedDropdownValue = 'Daily';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent column from expanding
          children: [
            // Header Row with controls
            _buildControlsRow(size.width),
            const SizedBox(height: 16),
            // Graph Container with fixed height
            _createGraph(),
            // Add other content here if needed
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0), // Adjust the radius as needed
        ),
      ),
      backgroundColor: secondaryColor.withAlpha(50),
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0.0,
      toolbarHeight: 90.0,
      elevation: 0,
      title: Column(
        children: [
          const AppHeaderWidget(),
          // WalletBalancesWidget(),
        ],
      ),
    );
  }

  Widget _buildControlsRow(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDownloadButton(),
        _buildCurrencyDropdown(),
        _buildPeriodDropdown(),
      ],
    );
  }

  Widget _buildDownloadButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Download Individual Report'),
            content: const Text('Choose download format'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  downloadReport();
                },
                child: const Text('CSV'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Implement PDF download
                },
                child: const Text('PDF'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.download, color: Colors.black, size: 16),
            SizedBox(width: 4),
            Text(
              'Download',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
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

  Widget _createGraph() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.35, // Reduced from 0.5 to 0.35
      padding: const EdgeInsets.symmetric(vertical: 8),
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
