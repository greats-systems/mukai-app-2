// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20250508174937.migration.dart';
part '20250508175234.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20250508174937(),
  const Migration20250508175234(),
};

/// A consumable database structure including the latest generated migration.
final schema = Schema(
  20250508175234,
  generatorVersion: 1,
  tables: <SchemaTable>{
    SchemaTable(
      '_brick_Cooperative_members',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn(
          'l_Cooperative_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Cooperative',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn(
          'f_Profile_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Profile',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
      },
      indices: <SchemaIndex>{
        SchemaIndex(
          columns: ['l_Cooperative_brick_id', 'f_Profile_brick_id'],
          unique: true,
        ),
      },
    ),
    SchemaTable(
      'Cooperative',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar, unique: true),
        SchemaColumn('name', Column.varchar),
        SchemaColumn('category', Column.varchar),
        SchemaColumn('city', Column.varchar),
        SchemaColumn('county', Column.varchar),
        SchemaColumn('province_state', Column.varchar),
        SchemaColumn('admin_id', Column.varchar),
        SchemaColumn('members', Column.varchar),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'Profile',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('password', Column.varchar),
        SchemaColumn('profile_image_url', Column.varchar),
        SchemaColumn('profile_image_id', Column.varchar),
        SchemaColumn('gender', Column.varchar),
        SchemaColumn('first_name', Column.varchar),
        SchemaColumn('last_name', Column.varchar),
        SchemaColumn('full_name', Column.varchar),
        SchemaColumn('profile_picture_id', Column.varchar),
        SchemaColumn('account_type', Column.varchar),
        SchemaColumn('email', Column.varchar),
        SchemaColumn('phone', Column.varchar),
        SchemaColumn('city', Column.varchar),
        SchemaColumn('country', Column.varchar),
        SchemaColumn('neighbourhood', Column.varchar),
        SchemaColumn('province_state', Column.varchar),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('wallet_balance', Column.Double),
        SchemaColumn('wallet_address', Column.varchar),
        SchemaColumn('push_token', Column.varchar),
        SchemaColumn('business', Column.varchar),
        SchemaColumn('last_access', Column.datetime),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn('permissions', Column.varchar),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'Transaction',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('category', Column.varchar),
        SchemaColumn('purpose', Column.varchar),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('sending_wallet', Column.varchar),
        SchemaColumn('account_id', Column.varchar),
        SchemaColumn('sending_phone', Column.varchar),
        SchemaColumn('receiving_wallet', Column.varchar),
        SchemaColumn('receiving_phone', Column.varchar),
        SchemaColumn('receiving_account_number', Column.varchar),
        SchemaColumn('recieving_profile_avatar', Column.varchar),
        SchemaColumn('sending_profile_avatar', Column.varchar),
        SchemaColumn('status', Column.varchar),
        SchemaColumn('transfer_mode', Column.varchar),
        SchemaColumn('transfer_category', Column.varchar),
        SchemaColumn('amount', Column.Double),
        SchemaColumn('created_at', Column.varchar),
        SchemaColumn('updated_at', Column.varchar),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'Wallet',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('category', Column.varchar),
        SchemaColumn('purpose', Column.varchar),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('wallet_adress', Column.varchar),
        SchemaColumn('account_id', Column.varchar),
        SchemaColumn('phone_number', Column.varchar),
        SchemaColumn('status', Column.varchar),
        SchemaColumn('created_at', Column.varchar),
        SchemaColumn('updated_at', Column.varchar),
        SchemaColumn('recent_balance', Column.Double),
      },
      indices: <SchemaIndex>{},
    ),
  },
);
