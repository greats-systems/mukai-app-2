// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250710103418_up = [
  DropColumn('purpose', onTable: 'Asset'),
  DropColumn('title', onTable: 'Asset'),
  DropColumn('wallet_address', onTable: 'Asset'),
  DropColumn('country', onTable: 'Asset'),
  DropColumn('city', onTable: 'Asset'),
  DropColumn('province', onTable: 'Asset'),
  DropColumn('neighborhood', onTable: 'Asset'),
  DropColumn('image_url', onTable: 'Asset'),
  DropColumn('is_group_wallet', onTable: 'Asset'),
  DropColumn('amount_value', onTable: 'Asset'),
  DropColumn('ownership_type', onTable: 'Asset'),
  InsertColumn('company_name', Column.varchar, onTable: 'Asset'),
  InsertColumn('email', Column.varchar, onTable: 'Asset')
];

const List<MigrationCommand> _migration_20250710103418_down = [
  DropColumn('company_name', onTable: 'Asset'),
  DropColumn('email', onTable: 'Asset')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250710103418',
  up: _migration_20250710103418_up,
  down: _migration_20250710103418_down,
)
class Migration20250710103418 extends Migration {
  const Migration20250710103418()
    : super(
        version: 20250710103418,
        up: _migration_20250710103418_up,
        down: _migration_20250710103418_down,
      );
}
