// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<FinancialArticle> _$FinancialArticleFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return FinancialArticle(
    id: data['id'] == null ? null : data['id'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    profileId:
        data['profile_id'] == null ? null : data['profile_id'] as String?,
    title: data['title'] == null ? null : data['title'] as String?,
    contentType:
        data['content_type'] == null ? null : data['content_type'] as String?,
    body: data['body'] == null ? null : data['body'] as String?,
    excerpt: data['excerpt'] == null ? null : data['excerpt'] as String?,
    coverImage:
        data['cover_image'] == null ? null : data['cover_image'] as String?,
    isFree: data['is_free'] == null ? null : data['is_free'] as bool?,
    price: data['price'] == null ? null : data['price'] as double?,
    currency: data['currency'] == null ? null : data['currency'] as String?,
    readingTime:
        data['reading_time'] == null ? null : data['reading_time'] as String?,
    publishedAt:
        data['published_at'] == null ? null : data['published_at'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    views: data['views'] == null ? null : data['views'] as int?,
    likes: data['likes'] == null ? null : data['likes'] as int?,
    commentsEnabled:
        data['comments_enabled'] == null
            ? null
            : data['comments_enabled'] as bool?,
  );
}

Future<Map<String, dynamic>> _$FinancialArticleToSupabase(
  FinancialArticle instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'created_at': instance.createdAt,
    'profile_id': instance.profileId,
    'title': instance.title,
    'content_type': instance.contentType,
    'body': instance.body,
    'excerpt': instance.excerpt,
    'cover_image': instance.coverImage,
    'is_free': instance.isFree,
    'price': instance.price,
    'currency': instance.currency,
    'reading_time': instance.readingTime,
    'published_at': instance.publishedAt,
    'status': instance.status,
    'views': instance.views,
    'likes': instance.likes,
    'comments_enabled': instance.commentsEnabled,
  };
}

Future<FinancialArticle> _$FinancialArticleFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return FinancialArticle(
    id: data['id'] == null ? null : data['id'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    profileId:
        data['profile_id'] == null ? null : data['profile_id'] as String?,
    title: data['title'] == null ? null : data['title'] as String?,
    contentType:
        data['content_type'] == null ? null : data['content_type'] as String?,
    body: data['body'] == null ? null : data['body'] as String?,
    excerpt: data['excerpt'] == null ? null : data['excerpt'] as String?,
    coverImage:
        data['cover_image'] == null ? null : data['cover_image'] as String?,
    isFree: data['is_free'] == null ? null : data['is_free'] == 1,
    price: data['price'] == null ? null : data['price'] as double?,
    currency: data['currency'] == null ? null : data['currency'] as String?,
    readingTime:
        data['reading_time'] == null ? null : data['reading_time'] as String?,
    publishedAt:
        data['published_at'] == null ? null : data['published_at'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    views: data['views'] == null ? null : data['views'] as int?,
    likes: data['likes'] == null ? null : data['likes'] as int?,
    commentsEnabled:
        data['comments_enabled'] == null ? null : data['comments_enabled'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$FinancialArticleToSqlite(
  FinancialArticle instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'created_at': instance.createdAt,
    'profile_id': instance.profileId,
    'title': instance.title,
    'content_type': instance.contentType,
    'body': instance.body,
    'excerpt': instance.excerpt,
    'cover_image': instance.coverImage,
    'is_free': instance.isFree == null ? null : (instance.isFree! ? 1 : 0),
    'price': instance.price,
    'currency': instance.currency,
    'reading_time': instance.readingTime,
    'published_at': instance.publishedAt,
    'status': instance.status,
    'views': instance.views,
    'likes': instance.likes,
    'comments_enabled':
        instance.commentsEnabled == null
            ? null
            : (instance.commentsEnabled! ? 1 : 0),
  };
}

/// Construct a [FinancialArticle]
class FinancialArticleAdapter
    extends OfflineFirstWithSupabaseAdapter<FinancialArticle> {
  FinancialArticleAdapter();

  @override
  final supabaseTableName = 'financial_articles';
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
    'profileId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'profile_id',
    ),
    'title': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'title',
    ),
    'contentType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'content_type',
    ),
    'body': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'body',
    ),
    'excerpt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'excerpt',
    ),
    'coverImage': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cover_image',
    ),
    'isFree': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_free',
    ),
    'price': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'price',
    ),
    'currency': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'currency',
    ),
    'readingTime': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'reading_time',
    ),
    'publishedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'published_at',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'views': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'views',
    ),
    'likes': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'likes',
    ),
    'commentsEnabled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'comments_enabled',
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
    'profileId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'profile_id',
      iterable: false,
      type: String,
    ),
    'title': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'title',
      iterable: false,
      type: String,
    ),
    'contentType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'content_type',
      iterable: false,
      type: String,
    ),
    'body': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'body',
      iterable: false,
      type: String,
    ),
    'excerpt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'excerpt',
      iterable: false,
      type: String,
    ),
    'coverImage': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cover_image',
      iterable: false,
      type: String,
    ),
    'isFree': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_free',
      iterable: false,
      type: bool,
    ),
    'price': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'price',
      iterable: false,
      type: double,
    ),
    'currency': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'currency',
      iterable: false,
      type: String,
    ),
    'readingTime': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'reading_time',
      iterable: false,
      type: String,
    ),
    'publishedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'published_at',
      iterable: false,
      type: String,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'views': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'views',
      iterable: false,
      type: int,
    ),
    'likes': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'likes',
      iterable: false,
      type: int,
    ),
    'commentsEnabled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'comments_enabled',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    FinancialArticle instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'FinancialArticle';

  @override
  Future<FinancialArticle> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinancialArticleFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    FinancialArticle input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinancialArticleToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<FinancialArticle> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinancialArticleFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    FinancialArticle input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinancialArticleToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
