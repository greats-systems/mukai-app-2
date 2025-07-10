// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Saving> _$SavingFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Saving(
    id: data['id'] == null ? null : data['id'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    walletId: data['wallet_id'] == null ? null : data['wallet_id'] as String?,
    profileId:
        data['profile_id'] == null ? null : data['profile_id'] as String?,
    groupId: data['group_id'] == null ? null : data['group_id'] as String?,
    purpose: data['purpose'] == null ? null : data['purpose'] as String?,
    lockEvent:
        data['lock_event'] == null ? null : data['lock_event'] as String?,
    currentBalance:
        data['current_balance'] == null
            ? null
            : data['current_balance'] as num?,
    lockFeature:
        data['lock_feature'] == null ? null : data['lock_feature'] as String?,
    lockMilestones:
        data['lock_milestones'] == null
            ? null
            : await Future.wait<Milestone>(
              data['lock_milestones']
                      ?.map(
                        (d) => MilestoneAdapter().fromSupabase(
                          d,
                          provider: provider,
                          repository: repository,
                        ),
                      )
                      .toList()
                      .cast<Future<Milestone>>() ??
                  [],
            ),
    lockDate: data['lock_date'] == null ? null : data['lock_date'] as String?,
    lockAmount:
        data['lock_amount'] == null ? null : data['lock_amount'] as num?,
    endorserId:
        data['endorser_id'] == null
            ? null
            : data['endorser_id']?.toList().cast<String>(),
    unlockingCode:
        data['unlocking_code'] == null
            ? null
            : data['unlocking_code'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    isLocked: data['is_locked'] == null ? null : data['is_locked'] as bool?,
    unlockKey:
        data['unlock_key'] == null ? null : data['unlock_key'] as String?,
    lastRecommendation:
        data['last_recommendation'] == null
            ? null
            : data['last_recommendation'] as String?,
    previousDepositDate:
        data['previous_deposit_date'] == null
            ? null
            : data['previous_deposit_date'] as String?,
  );
}

Future<Map<String, dynamic>> _$SavingToSupabase(
  Saving instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'created_at': instance.createdAt,
    'wallet_id': instance.walletId,
    'profile_id': instance.profileId,
    'group_id': instance.groupId,
    'purpose': instance.purpose,
    'lock_event': instance.lockEvent,
    'current_balance': instance.currentBalance,
    'lock_feature': instance.lockFeature,
    'lock_milestones': await Future.wait<Map<String, dynamic>>(
      instance.lockMilestones
              ?.map(
                (s) => MilestoneAdapter().toSupabase(
                  s,
                  provider: provider,
                  repository: repository,
                ),
              )
              .toList() ??
          [],
    ),
    'lock_date': instance.lockDate,
    'lock_amount': instance.lockAmount,
    'endorser_id': instance.endorserId,
    'unlocking_code': instance.unlockingCode,
    'status': instance.status,
    'is_locked': instance.isLocked,
    'unlock_key': instance.unlockKey,
    'last_recommendation': instance.lastRecommendation,
    'previous_deposit_date': instance.previousDepositDate,
  };
}

Future<Saving> _$SavingFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Saving(
    id: data['id'] == null ? null : data['id'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    walletId: data['wallet_id'] == null ? null : data['wallet_id'] as String?,
    profileId:
        data['profile_id'] == null ? null : data['profile_id'] as String?,
    groupId: data['group_id'] == null ? null : data['group_id'] as String?,
    purpose: data['purpose'] == null ? null : data['purpose'] as String?,
    lockEvent:
        data['lock_event'] == null ? null : data['lock_event'] as String?,
    currentBalance:
        data['current_balance'] == null
            ? null
            : data['current_balance'] as num?,
    lockFeature:
        data['lock_feature'] == null ? null : data['lock_feature'] as String?,
    lockMilestones:
        (await provider
            .rawQuery(
              'SELECT DISTINCT `f_Milestone_brick_id` FROM `_brick_Saving_lock_milestones` WHERE l_Saving_brick_id = ?',
              [data['_brick_id'] as int],
            )
            .then((results) {
              final ids = results.map((r) => r['f_Milestone_brick_id']);
              return Future.wait<Milestone>(
                ids.map(
                  (primaryKey) => repository!
                      .getAssociation<Milestone>(
                        Query.where('primaryKey', primaryKey, limit1: true),
                      )
                      .then((r) => r!.first),
                ),
              );
            })).toList().cast<Milestone>(),
    lockDate: data['lock_date'] == null ? null : data['lock_date'] as String?,
    lockAmount:
        data['lock_amount'] == null ? null : data['lock_amount'] as num?,
    endorserId:
        data['endorser_id'] == null
            ? null
            : jsonDecode(data['endorser_id']).toList().cast<String>(),
    unlockingCode:
        data['unlocking_code'] == null
            ? null
            : data['unlocking_code'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    isLocked: data['is_locked'] == null ? null : data['is_locked'] == 1,
    unlockKey:
        data['unlock_key'] == null ? null : data['unlock_key'] as String?,
    lastRecommendation:
        data['last_recommendation'] == null
            ? null
            : data['last_recommendation'] as String?,
    previousDepositDate:
        data['previous_deposit_date'] == null
            ? null
            : data['previous_deposit_date'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$SavingToSqlite(
  Saving instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'created_at': instance.createdAt,
    'wallet_id': instance.walletId,
    'profile_id': instance.profileId,
    'group_id': instance.groupId,
    'purpose': instance.purpose,
    'lock_event': instance.lockEvent,
    'current_balance': instance.currentBalance,
    'lock_feature': instance.lockFeature,
    'lock_date': instance.lockDate,
    'lock_amount': instance.lockAmount,
    'endorser_id':
        instance.endorserId == null ? null : jsonEncode(instance.endorserId),
    'unlocking_code': instance.unlockingCode,
    'status': instance.status,
    'is_locked':
        instance.isLocked == null ? null : (instance.isLocked! ? 1 : 0),
    'unlock_key': instance.unlockKey,
    'last_recommendation': instance.lastRecommendation,
    'previous_deposit_date': instance.previousDepositDate,
  };
}

/// Construct a [Saving]
class SavingAdapter extends OfflineFirstWithSupabaseAdapter<Saving> {
  SavingAdapter();

  @override
  final supabaseTableName = 'savings';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'walletId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'wallet_id',
    ),
    'profileId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'profile_id',
    ),
    'groupId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'group_id',
    ),
    'purpose': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'purpose',
    ),
    'lockEvent': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'lock_event',
    ),
    'currentBalance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'current_balance',
    ),
    'lockFeature': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'lock_feature',
    ),
    'lockMilestones': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'lock_milestones',
      associationType: Milestone,
      associationIsNullable: true,
    ),
    'lockDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'lock_date',
    ),
    'lockAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'lock_amount',
    ),
    'endorserId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'endorser_id',
    ),
    'unlockingCode': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'unlocking_code',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'isLocked': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_locked',
    ),
    'unlockKey': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'unlock_key',
    ),
    'lastRecommendation': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_recommendation',
    ),
    'previousDepositDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'previous_deposit_date',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: String,
    ),
    'walletId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'wallet_id',
      iterable: false,
      type: String,
    ),
    'profileId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'profile_id',
      iterable: false,
      type: String,
    ),
    'groupId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'group_id',
      iterable: false,
      type: String,
    ),
    'purpose': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'purpose',
      iterable: false,
      type: String,
    ),
    'lockEvent': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'lock_event',
      iterable: false,
      type: String,
    ),
    'currentBalance': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'current_balance',
      iterable: false,
      type: num,
    ),
    'lockFeature': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'lock_feature',
      iterable: false,
      type: String,
    ),
    'lockMilestones': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'lock_milestones',
      iterable: true,
      type: Milestone,
    ),
    'lockDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'lock_date',
      iterable: false,
      type: String,
    ),
    'lockAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'lock_amount',
      iterable: false,
      type: num,
    ),
    'endorserId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'endorser_id',
      iterable: true,
      type: String,
    ),
    'unlockingCode': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'unlocking_code',
      iterable: false,
      type: String,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'isLocked': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_locked',
      iterable: false,
      type: bool,
    ),
    'unlockKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'unlock_key',
      iterable: false,
      type: String,
    ),
    'lastRecommendation': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_recommendation',
      iterable: false,
      type: String,
    ),
    'previousDepositDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'previous_deposit_date',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Saving instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Saving` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Saving';
  @override
  Future<void> afterSave(instance, {required provider, repository}) async {
    if (instance.primaryKey != null) {
      final lockMilestonesOldColumns = await provider.rawQuery(
        'SELECT `f_Milestone_brick_id` FROM `_brick_Saving_lock_milestones` WHERE `l_Saving_brick_id` = ?',
        [instance.primaryKey],
      );
      final lockMilestonesOldIds = lockMilestonesOldColumns.map(
        (a) => a['f_Milestone_brick_id'],
      );
      final lockMilestonesNewIds =
          instance.lockMilestones?.map((s) => s.primaryKey).whereType<int>() ??
          [];
      final lockMilestonesIdsToDelete = lockMilestonesOldIds.where(
        (id) => !lockMilestonesNewIds.contains(id),
      );

      await Future.wait<void>(
        lockMilestonesIdsToDelete.map((id) async {
          return await provider
              .rawExecute(
                'DELETE FROM `_brick_Saving_lock_milestones` WHERE `l_Saving_brick_id` = ? AND `f_Milestone_brick_id` = ?',
                [instance.primaryKey, id],
              )
              .catchError((e) => null);
        }),
      );

      await Future.wait<int?>(
        instance.lockMilestones?.map((s) async {
              final id =
                  s.primaryKey ??
                  await provider.upsert<Milestone>(s, repository: repository);
              return await provider.rawInsert(
                'INSERT OR IGNORE INTO `_brick_Saving_lock_milestones` (`l_Saving_brick_id`, `f_Milestone_brick_id`) VALUES (?, ?)',
                [instance.primaryKey, id],
              );
            }) ??
            [],
      );
    }
  }

  @override
  Future<Saving> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SavingFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Saving input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SavingToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Saving> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SavingFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Saving input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$SavingToSqlite(input, provider: provider, repository: repository);
}
