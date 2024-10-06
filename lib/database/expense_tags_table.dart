import 'package:drift/drift.dart';
import 'package:xpenses/database/expense_table.dart';
import 'package:xpenses/database/tag_table.dart';

@DataClassName('ExpenseTagsEntry')
class ExpenseTagsTable extends Table {
  IntColumn get expenseId => integer().references(ExpenseTable, #id)();
  IntColumn get tagId => integer().references(TagTable, #id)();
}
