import 'package:drift/drift.dart';
import 'package:xpenses/database/expense_table.dart';

@DataClassName('InstallmentEntry')
class InstallmentTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get expenseId => integer().references(ExpenseTable, #id)();
  IntColumn get valueCents =>
      // ignore: recursive_getters
      integer().check(valueCents.isBiggerThanValue(0))();
  IntColumn get index => integer()();
  DateTimeColumn get date => dateTime()();
}
