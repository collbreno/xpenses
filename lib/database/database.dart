import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:xpenses/database/expense_table.dart';
import 'package:xpenses/database/expense_tags_table.dart';
import 'package:xpenses/database/installment_table.dart';
import 'package:xpenses/database/person_part_table.dart';
import 'package:xpenses/database/person_payment_table.dart';
import 'package:xpenses/database/tag_table.dart';
import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/models/installment_model.dart';
import 'package:xpenses/models/tag_model.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  ExpenseTable,
  ExpenseTagsTable,
  InstallmentTable,
  PersonPartTable,
  TagTable,
  PersonPaymentTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'app_database');
  }

  Future<List<Tag>> getAllTags() async {
    final entries = await select(tagTable).get();
    return entries.map((e) => Tag.fromTable(e)).toList();
  }

  Future<int> addTag(Tag model) async {
    final tag = TagTableCompanion(
      colorCode: Value(model.color.value),
      iconName: Value(model.iconName),
      name: Value(model.name),
      id: const Value.absent(),
    );

    return into(tagTable).insert(tag);
  }

  Future<bool> updateTag(Tag model) async {
    final tag = TagTableCompanion(
      colorCode: Value(model.color.value),
      iconName: Value(model.iconName),
      name: Value(model.name),
      id: Value(model.id),
    );

    return update(tagTable).replace(tag);
  }

  Future<List<Installment>> getAllInstallments() async {
    final query = select(installmentTable).join([
      innerJoin(
          expenseTable, expenseTable.id.equalsExp(installmentTable.expenseId)),
      leftOuterJoin(
        personPartTable,
        personPartTable.installmentId.equalsExp(installmentTable.id),
      )
    ]);

    final rows = await query.get();
    final groups = rows.groupListsBy((row) => row.read(installmentTable.id));

    return groups.entries.map((entry) {
      final rows = entry.value;
      final personParts = entry.value.map(
        (row) => row.readTableOrNull(personPartTable),
      );
      return Installment.fromTable(
        rows.first.readTable(installmentTable),
        personPartEntries: personParts.whereNotNull(),
        expenseEntry: rows.first.readTable(expenseTable),
      );
    }).toList();
  }

  Future<int> addExpense(Expense model) async {
    final expense = ExpenseTableCompanion(
      createdAt: Value(model.createdAt),
      description: Value(model.description),
      title: Value(model.title),
      updatedAt: Value(model.updatedAt),
    );

    final expenseId = await into(expenseTable).insert(expense);

    await Future.forEach(model.tags, (t) async {
      final expenseTag = ExpenseTagsTableCompanion(
        expenseId: Value(expenseId),
        tagId: Value(t.id),
      );
      await into(expenseTagsTable).insert(expenseTag);
    });

    await Future.forEach(model.installments!, (i) async {
      final installment = InstallmentTableCompanion(
        date: Value(i.date),
        expenseId: Value(expenseId),
        index: Value(i.index),
        valueCents: Value(i.value.minorUnits.toInt()),
      );

      final installmentId = await into(installmentTable).insert(installment);

      await Future.forEach(i.personParts, (p) async {
        await into(personPartTable).insert(
          PersonPartTableCompanion(
            installmentId: Value(installmentId),
            name: Value(p.name),
            valueCents: Value(p.value.minorUnits.toInt()),
          ),
        );
      });
    });

    return expenseId;
  }
}
