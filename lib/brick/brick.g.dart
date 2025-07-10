// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_core/query.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/db.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'dart:developer';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/brick_sqlite.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_supabase/brick_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:mukai/brick/models/profile.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:mukai/brick/models/milestones.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:uuid/uuid.dart';// GENERATED CODE DO NOT EDIT
// ignore: unused_import
import 'dart:convert';
import 'package:brick_sqlite/brick_sqlite.dart' show SqliteModel, SqliteAdapter, SqliteModelDictionary, RuntimeSqliteColumnDefinition, SqliteProvider;
import 'package:brick_supabase/brick_supabase.dart' show SupabaseProvider, SupabaseModel, SupabaseAdapter, SupabaseModelDictionary;
// ignore: unused_import, unused_shown_name
import 'package:brick_offline_first/brick_offline_first.dart' show RuntimeOfflineFirstDefinition;
// ignore: unused_import, unused_shown_name
import 'package:sqflite_common/sqlite_api.dart' show DatabaseExecutor;

import '../brick/models/asset.model.dart';
import '../brick/models/coop.model.dart';
import '../brick/models/financial-article.model.dart';
import '../brick/models/financial_report.model.dart';
import '../brick/models/group.model.dart';
import '../brick/models/group_members.model.dart';
import '../brick/models/loan.model.dart';
import '../brick/models/milestones.model.dart';
import '../brick/models/profile.model.dart';
import '../brick/models/saving.model.dart';
import '../brick/models/transaction.model.dart';
import '../brick/models/wallet.model.dart';

part 'adapters/asset_adapter.g.dart';
part 'adapters/cooperative_adapter.g.dart';
part 'adapters/financial_article_adapter.g.dart';
part 'adapters/financial_report_adapter.g.dart';
part 'adapters/group_adapter.g.dart';
part 'adapters/group_members_adapter.g.dart';
part 'adapters/loan_adapter.g.dart';
part 'adapters/milestone_adapter.g.dart';
part 'adapters/profile_adapter.g.dart';
part 'adapters/saving_adapter.g.dart';
part 'adapters/transaction_adapter.g.dart';
part 'adapters/wallet_adapter.g.dart';

/// Supabase mappings should only be used when initializing a [SupabaseProvider]
final Map<Type, SupabaseAdapter<SupabaseModel>> supabaseMappings = {
  Asset: AssetAdapter(),
  Cooperative: CooperativeAdapter(),
  FinancialArticle: FinancialArticleAdapter(),
  FinancialReport: FinancialReportAdapter(),
  Group: GroupAdapter(),
  GroupMembers: GroupMembersAdapter(),
  Loan: LoanAdapter(),
  Milestone: MilestoneAdapter(),
  Profile: ProfileAdapter(),
  Saving: SavingAdapter(),
  Transaction: TransactionAdapter(),
  Wallet: WalletAdapter()
};
final supabaseModelDictionary = SupabaseModelDictionary(supabaseMappings);

/// Sqlite mappings should only be used when initializing a [SqliteProvider]
final Map<Type, SqliteAdapter<SqliteModel>> sqliteMappings = {
  Asset: AssetAdapter(),
  Cooperative: CooperativeAdapter(),
  FinancialArticle: FinancialArticleAdapter(),
  FinancialReport: FinancialReportAdapter(),
  Group: GroupAdapter(),
  GroupMembers: GroupMembersAdapter(),
  Loan: LoanAdapter(),
  Milestone: MilestoneAdapter(),
  Profile: ProfileAdapter(),
  Saving: SavingAdapter(),
  Transaction: TransactionAdapter(),
  Wallet: WalletAdapter()
};
final sqliteModelDictionary = SqliteModelDictionary(sqliteMappings);
