import 'package:drift/drift.dart';

@DataClassName('TagEntry')
class TagTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 20)();
  TextColumn get iconName => text().withLength(min: 0)();
  IntColumn get colorCode => integer()();
}
