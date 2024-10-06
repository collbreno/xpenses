import 'package:drift/drift.dart';
import 'package:xpenses/database/installment_table.dart';

@DataClassName('PersonPartEntry')
class PersonPartTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get installmentId => integer().references(InstallmentTable, #id)();
  IntColumn get valueCents =>
      // ignore: recursive_getters
      integer().check(valueCents.isBiggerThan((const Constant(0))))();
  TextColumn get name => text().withLength(min: 1)();
}
