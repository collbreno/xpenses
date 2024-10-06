import 'package:drift/drift.dart';

@DataClassName('PersonPaymentEntry')
class PersonPaymentTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get valueCents =>
      // ignore: recursive_getters
      integer().check(valueCents.isBiggerThanValue(0))();
  TextColumn get name => text().withLength(min: 1)();
  DateTimeColumn get date => dateTime()();
}
