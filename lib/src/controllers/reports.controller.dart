import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:mukai/constants.dart' as constants;
import 'package:mukai/main.dart';

final GetStorage _getStorage = GetStorage();

Future<String> fetchWalletId() async {
  final id = await _getStorage.read('walletId');
  return id;
}

class ReportsController {
  Future<Map<String, dynamic>?> getTotalDailyDeposits() async {
    final walletId = await fetchWalletId();
    try {
      final response = await supabase
          .from('transactions')
          .select('''
      sum(amount) as total_daily_deposits,
    ${constants.truncateDate('day')} as date,   
    ''')
    .eq('sending_wallet', walletId)
          .eq('receiving_wallet', walletId)
          .eq('transaction_type', 'deposit')
          .single();
      return response;
    } catch (e, s) {
      log('getTotalDailyDeposits error: $e $s');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTotalDailyWithdrawals() async {
    final walletId = await fetchWalletId();
    try {
      final response = await supabase
          .from('transactions')
          .select('''
      sum(amount) as total_daily_withdrawals,
    ${constants.truncateDate('day')} as date,   
    ''')
    .eq('sending_wallet', walletId)
          .eq('receiving_wallet', walletId)
          .eq('transaction_type', 'withdrawal')
          .single();
      return response;
    } catch (e, s) {
      log('getTotalDailyWithdrawals error: $e $s');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTotalWeeklyDeposits() async {
    final walletId = await fetchWalletId();
    try {
      final response = await supabase
          .from('transactions')
          .select('''
      sum(amount) as total_weekly_deposits,
    ${constants.truncateDate('week')} as date,   
    ''')
    .eq('sending_wallet', walletId)
          .eq('receiving_wallet', walletId)
          .eq('transaction_type', 'deposit')
          .single();
      return response;
    } catch (e, s) {
      log('getTotalWeeklyDeposits error: $e $s');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTotalWeeklyWithdrawals() async {
    final walletId = await fetchWalletId();
    try {
      final response = await supabase
          .from('transactions')
          .select('''
      sum(amount) as total_weekly_withdrawals,
    ${constants.truncateDate('week')} as date,   
    ''')
    .eq('sending_wallet', walletId)
          .eq('receiving_wallet', walletId)
          .eq('transaction_type', 'withdrawal')
          .single();
      return response;
    } catch (e, s) {
      log('getTotalWeeklyWithdrawals error: $e $s');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTotalMonthlyDeposits() async {
    final walletId = await fetchWalletId();
    try {
      final response = await supabase
          .from('transactions')
          .select('''
      sum(amount) as total_monthly_deposits,
    ${constants.truncateDate('month')} as date,   
    ''')
          .eq('receiving_wallet', walletId)
          .eq('transaction_type', 'deposit')
          .single();
      return response;
    } catch (e, s) {
      log('getTotalMonthlyDeposits error: $e $s');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTotalMonthlyWithdrawals() async {
    final walletId = await fetchWalletId();
    try {
      final response = await supabase
          .from('transactions')
          .select('''
      sum(amount) as total_monthly_withdrawals,
    ${constants.truncateDate('week')} as date,   
    ''')
          .eq('receiving_wallet', walletId)
          .eq('transaction_type', 'withdrawal')
          .single();
      return response;
    } catch (e, s) {
      log('getTotalMonthlyWithdrawals error: $e $s');
      return null;
    }
  }
}
