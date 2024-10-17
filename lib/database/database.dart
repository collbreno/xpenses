import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:money2/src/money.dart';
import 'package:xpenses/database/expense_table.dart';
import 'package:xpenses/database/expense_tags_table.dart';
import 'package:xpenses/database/i_database.dart';
import 'package:xpenses/database/installment_table.dart';
import 'package:xpenses/database/person_part_table.dart';
import 'package:xpenses/database/person_payment_table.dart';
import 'package:xpenses/database/tag_table.dart';
import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/models/installment_model.dart';
import 'package:xpenses/models/pending_payment.dart';
import 'package:xpenses/models/tag_model.dart';
import 'package:xpenses/utils/money_utils.dart';
import 'package:xpenses/utils/month.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  ExpenseTable,
  ExpenseTagsTable,
  InstallmentTable,
  PersonPartTable,
  TagTable,
  PersonPaymentTable,
])
class AppDatabase extends _$AppDatabase implements IAppDatabase {
  AppDatabase(super.e);
  @override
  int get schemaVersion => 1;

  static QueryExecutor openConnection() {
    return driftDatabase(name: 'app_database');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

  @override
  Future<List<Tag>> getAllTags() async {
    final entries = await select(tagTable).get();
    return entries.map((e) => Tag.fromTable(e)).toList();
  }

  @override
  Future<int> addTag(Tag model) async {
    final tag = TagTableCompanion(
      colorCode: Value(model.color.value),
      iconName: Value(model.iconName),
      name: Value(model.name),
      id: const Value.absent(),
    );

    return into(tagTable).insert(tag);
  }

  @override
  Future<bool> updateTag(Tag model) async {
    final tag = TagTableCompanion(
      colorCode: Value(model.color.value),
      iconName: Value(model.iconName),
      name: Value(model.name),
      id: Value(model.id),
    );

    return update(tagTable).replace(tag);
  }

  @override
  Future<List<Installment>> getInstallments(Month month) async {
    final allInstallments = Subquery(select(installmentTable), 's');

    final amount =
        allInstallments.ref(installmentTable.id).count(distinct: true);

    final query = select(installmentTable).join([
      innerJoin(
          expenseTable, expenseTable.id.equalsExp(installmentTable.expenseId)),
      leftOuterJoin(
        personPartTable,
        personPartTable.installmentId.equalsExp(installmentTable.id),
      ),
      innerJoin(
        allInstallments,
        allInstallments
            .ref(installmentTable.expenseId)
            .equalsExp(expenseTable.id),
      ),
    ])
      ..where(
        installmentTable.date.isBetweenValues(month.firstDay, month.lastDay),
      )
      ..orderBy([OrderingTerm.desc(installmentTable.date)])
      ..addColumns([amount])
      ..groupBy([installmentTable.expenseId]);

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
        totalCount: rows.first.read(amount),
      );
    }).toList();
  }

  @override
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

  @override
  Future<DateTimeRange> getExpensesDateTimeRange() {
    final min = installmentTable.date.min();
    final max = installmentTable.date.max();
    final query = selectOnly(installmentTable)..addColumns([min, max]);
    return query
        .map((row) => DateTimeRange(
              start: row.read(min)!,
              end: row.read(max)!,
            ))
        .getSingle();
  }

  @override
  Stream<Money> watchTotalByMonth(Month month) {
    final totalValue = installmentTable.valueCents.sum();
    final query = selectOnly(installmentTable)
      ..where(
        installmentTable.date.isBetweenValues(month.firstDay, month.lastDay),
      )
      ..addColumns([totalValue]);

    return query
        .map((row) => MoneyUtils.fromCents(row.read(totalValue) ?? 0))
        .watchSingle();
  }

  @override
  Stream<List<PendingPayment>> watchPendingPayments(DateTime until) {
    //TODO: remove installments already paid
    final sum = personPartTable.valueCents.sum();
    final query = select(personPartTable).join([
      leftOuterJoin(
        installmentTable,
        installmentTable.id.equalsExp(personPartTable.installmentId),
      ),
    ])
      ..where(installmentTable.date.isSmallerOrEqualValue(until))
      ..addColumns([sum])
      ..groupBy([personPartTable.name]);

    return query.watch().map(
          (rows) => rows
              .map((row) => PendingPayment(
                    name: row.read(personPartTable.name)!,
                    value: MoneyUtils.fromCents(row.read(sum)!),
                  ))
              .toList(),
        );
  }
}
