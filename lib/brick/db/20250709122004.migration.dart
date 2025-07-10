// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250709122004_up = [
  InsertTable('_brick_Saving_lock_milestones'),
  InsertColumn('ownership_type', Column.varchar, onTable: 'Asset'),
  InsertForeignKey('_brick_Saving_lock_milestones', 'Saving', foreignKeyColumn: 'l_Saving_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('_brick_Saving_lock_milestones', 'Milestone', foreignKeyColumn: 'f_Milestone_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  CreateIndex(columns: ['l_Saving_brick_id', 'f_Milestone_brick_id'], onTable: '_brick_Saving_lock_milestones', unique: true)
];

const List<MigrationCommand> _migration_20250709122004_down = [
  DropTable('_brick_Saving_lock_milestones'),
  DropColumn('ownership_type', onTable: 'Asset'),
  DropColumn('l_Saving_brick_id', onTable: '_brick_Saving_lock_milestones'),
  DropColumn('f_Milestone_brick_id', onTable: '_brick_Saving_lock_milestones'),
  DropIndex('index__brick_Saving_lock_milestones_on_l_Saving_brick_id_f_Milestone_brick_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250709122004',
  up: _migration_20250709122004_up,
  down: _migration_20250709122004_down,
)
class Migration20250709122004 extends Migration {
  const Migration20250709122004()
    : super(
        version: 20250709122004,
        up: _migration_20250709122004_up,
        down: _migration_20250709122004_down,
      );
}
