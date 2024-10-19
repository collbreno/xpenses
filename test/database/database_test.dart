import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xpenses/database/database.dart';
import 'package:xpenses/models/pending_payment.dart';
import 'package:xpenses/utils/money_utils.dart';
import 'package:xpenses/utils/month.dart';

import '../fixtures/expense_fixture.dart';
import '../fixtures/tag_fixture.dart';

void main() {
  late TagFixture tagFix;
  late ExpenseFixture expenseFix;
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tagFix = TagFixture();
    expenseFix = ExpenseFixture();
  });

  tearDown(() async {
    await db.close();
  });

  group('Foreign keys', () {
    test('when primary key does not exist', () async {
      final result = db.into(db.expenseTagsTable).insert(const ExpenseTagsEntry(
            expenseId: 1,
            tagId: 1,
          ));
      await expectLater(result, throwsA(isA<SqliteException>()));
    });
    test('when primary key exists', () async {
      await db.into(db.expenseTable).insert(ExpenseEntry(
            id: 1,
            title: 'test',
            description: 'test',
            createdAt: DateTime(2024),
            updatedAt: DateTime(2024),
          ));
      await db.into(db.tagTable).insert(const TagEntry(
            id: 1,
            name: 'test',
            iconName: 'test',
            colorCode: 10,
          ));
      final result = db.into(db.expenseTagsTable).insert(const ExpenseTagsEntry(
            expenseId: 1,
            tagId: 1,
          ));
      await expectLater(result, completion(1));
    });
  });

  group('Tags', () {
    test('writing tag', () async {
      var result = await db.select(db.tagTable).get();
      expect(result, isEmpty);

      final tag = tagFix.tag1;
      await db.addTag(tag);
      result = await db.select(db.tagTable).get();
      expect(result, hasLength(1));

      final fromDb = result.single;
      expect(fromDb.colorCode, tag.color.value);
      expect(fromDb.name, tag.name);
      expect(fromDb.iconName, tag.iconName);
      expect(fromDb.id, 1);
    });

    test('reading tags', () async {
      var result = await db.getAllTags();
      expect(result, isEmpty);

      final tag1 = tagFix.tag1;
      final tag2 = tagFix.tag2;
      await db.addTag(tag1);
      result = await db.getAllTags();

      expect(result, hasLength(1));
      expect(result, [tag1.copyWithId(1)]);

      await db.addTag(tag2);
      result = await db.getAllTags();

      expect(result, hasLength(2));
      expect(result, [tag1.copyWithId(1), tag2.copyWithId(2)]);
    });
  });

  group('Expenses', () {
    test('writing expense (no tags, no people, one installment)', () async {
      final expense = expenseFix.expense1;
      var expenseRows = await db.select(db.expenseTable).get();
      var expenseTagsRows = await db.select(db.expenseTagsTable).get();
      var installmentRows = await db.select(db.installmentTable).get();
      var personPartRows = await db.select(db.personPartTable).get();

      expect(expenseRows, isEmpty);
      expect(expenseTagsRows, isEmpty);
      expect(installmentRows, isEmpty);
      expect(personPartRows, isEmpty);

      await db.addExpense(expense);

      expenseRows = await db.select(db.expenseTable).get();
      expenseTagsRows = await db.select(db.expenseTagsTable).get();
      installmentRows = await db.select(db.installmentTable).get();
      personPartRows = await db.select(db.personPartTable).get();

      expect(expenseRows, hasLength(1));
      final expenseRow = expenseRows.single;
      expect(expenseRow.id, 1);
      expect(expenseRow.title, expense.title);
      expect(expenseRow.description, expense.description);
      expect(expenseRow.createdAt, expense.createdAt);
      expect(expenseRow.updatedAt, expense.updatedAt);

      expect(expenseTagsRows, isEmpty);

      expect(installmentRows, hasLength(1));
      final installmentRow = installmentRows.single;
      expect(installmentRow.id, 1);
      expect(installmentRow.expenseId, 1);
      expect(
        installmentRow.valueCents,
        expense.installments!.single.value.minorUnits.toInt(),
      );
      expect(installmentRow.index, 0);
      expect(installmentRow.date, expense.installments!.single.date);

      expect(personPartRows, isEmpty);
    });

    test('writing expense (with tags)', () async {
      final expense = expenseFix.expenseWithTags;
      await db.addTag(tagFix.tag1);
      await db.addTag(tagFix.tag2);

      var expenseRows = await db.select(db.expenseTable).get();
      var expenseTagsRows = await db.select(db.expenseTagsTable).get();
      var installmentRows = await db.select(db.installmentTable).get();
      var personPartRows = await db.select(db.personPartTable).get();

      expect(expenseRows, isEmpty);
      expect(expenseTagsRows, isEmpty);
      expect(installmentRows, isEmpty);
      expect(personPartRows, isEmpty);

      await db.addExpense(expense);

      expenseRows = await db.select(db.expenseTable).get();
      expenseTagsRows = await db.select(db.expenseTagsTable).get();
      installmentRows = await db.select(db.installmentTable).get();
      personPartRows = await db.select(db.personPartTable).get();

      expect(expenseRows, hasLength(1));
      final expenseRow = expenseRows.single;
      expect(expenseRow.id, 1);
      expect(expenseRow.title, expense.title);
      expect(expenseRow.description, expense.description);
      expect(expenseRow.createdAt, expense.createdAt);
      expect(expenseRow.updatedAt, expense.updatedAt);

      expect(expenseTagsRows, hasLength(2));
      expect(expenseTagsRows[0].expenseId, 1);
      expect(expenseTagsRows[0].tagId, 1);
      expect(expenseTagsRows[1].expenseId, 1);
      expect(expenseTagsRows[1].tagId, 2);

      expect(installmentRows, hasLength(1));
      final installmentRow = installmentRows.single;
      expect(installmentRow.id, 1);
      expect(installmentRow.expenseId, 1);
      expect(installmentRow.valueCents, 3500);
      expect(installmentRow.index, 0);
      expect(installmentRow.date, DateTime(2024, 10, 3));

      expect(personPartRows, isEmpty);
    });

    test('writing expense (with people)', () async {
      final expense = expenseFix.expenseWithPeople;
      var expenseRows = await db.select(db.expenseTable).get();
      var expenseTagsRows = await db.select(db.expenseTagsTable).get();
      var installmentRows = await db.select(db.installmentTable).get();
      var personPartRows = await db.select(db.personPartTable).get();

      expect(expenseRows, isEmpty);
      expect(expenseTagsRows, isEmpty);
      expect(installmentRows, isEmpty);
      expect(personPartRows, isEmpty);

      await db.addExpense(expense);

      expenseRows = await db.select(db.expenseTable).get();
      expenseTagsRows = await db.select(db.expenseTagsTable).get();
      installmentRows = await db.select(db.installmentTable).get();
      personPartRows = await db.select(db.personPartTable).get();

      expect(expenseRows, hasLength(1));
      final expenseRow = expenseRows.single;
      expect(expenseRow.id, 1);
      expect(expenseRow.title, expense.title);
      expect(expenseRow.description, expense.description);
      expect(expenseRow.createdAt, expense.createdAt);
      expect(expenseRow.updatedAt, expense.updatedAt);

      expect(expenseTagsRows, isEmpty);

      expect(installmentRows, hasLength(1));
      final installmentRow = installmentRows.single;
      expect(installmentRow.id, 1);
      expect(installmentRow.expenseId, 1);
      expect(installmentRow.valueCents, 3500);
      expect(installmentRow.index, 0);
      expect(installmentRow.date, DateTime(2024, 10, 3));

      expect(personPartRows, hasLength(2));
      expect(personPartRows[0].id, 1);
      expect(personPartRows[0].installmentId, 1);
      expect(personPartRows[0].name, 'Pessoa 1');
      expect(personPartRows[0].valueCents, 1000);
      expect(personPartRows[1].id, 2);
      expect(personPartRows[1].installmentId, 1);
      expect(personPartRows[1].name, 'Pessoa 2');
      expect(personPartRows[1].valueCents, 1500);
    });

    test('writing expense (with installments)', () async {
      final expense = expenseFix.expenseWithInstallments;
      var expenseRows = await db.select(db.expenseTable).get();
      var expenseTagsRows = await db.select(db.expenseTagsTable).get();
      var installmentRows = await db.select(db.installmentTable).get();
      var personPartRows = await db.select(db.personPartTable).get();

      expect(expenseRows, isEmpty);
      expect(expenseTagsRows, isEmpty);
      expect(installmentRows, isEmpty);
      expect(personPartRows, isEmpty);

      await db.addExpense(expense);

      expenseRows = await db.select(db.expenseTable).get();
      expenseTagsRows = await db.select(db.expenseTagsTable).get();
      installmentRows = await db.select(db.installmentTable).get();
      personPartRows = await db.select(db.personPartTable).get();

      expect(expenseRows, hasLength(1));
      final expenseRow = expenseRows.single;
      expect(expenseRow.id, 1);
      expect(expenseRow.title, expense.title);
      expect(expenseRow.description, expense.description);
      expect(expenseRow.createdAt, expense.createdAt);
      expect(expenseRow.updatedAt, expense.updatedAt);

      expect(expenseTagsRows, isEmpty);

      expect(installmentRows, hasLength(2));
      expect(installmentRows[0].id, 1);
      expect(installmentRows[0].expenseId, 1);
      expect(installmentRows[0].valueCents, 3500);
      expect(installmentRows[0].index, 0);
      expect(installmentRows[0].date, DateTime(2024, 10, 3));
      expect(installmentRows[1].id, 2);
      expect(installmentRows[1].expenseId, 1);
      expect(installmentRows[1].valueCents, 4000);
      expect(installmentRows[1].index, 1);
      expect(installmentRows[1].date, DateTime(2024, 11, 3));

      expect(personPartRows, isEmpty);
    });

    test('writing expense (complete)', () async {
      await db.addTag(tagFix.tag1);
      await db.addTag(tagFix.tag2);

      final expense = expenseFix.expenseComplete;
      var expenseRows = await db.select(db.expenseTable).get();
      var expenseTagsRows = await db.select(db.expenseTagsTable).get();
      var installmentRows = await db.select(db.installmentTable).get();
      var personPartRows = await db.select(db.personPartTable).get();

      expect(expenseRows, isEmpty);
      expect(expenseTagsRows, isEmpty);
      expect(installmentRows, isEmpty);
      expect(personPartRows, isEmpty);

      await db.addExpense(expense);

      expenseRows = await db.select(db.expenseTable).get();
      expenseTagsRows = await db.select(db.expenseTagsTable).get();
      installmentRows = await db.select(db.installmentTable).get();
      personPartRows = await db.select(db.personPartTable).get();

      expect(expenseRows, hasLength(1));
      final expenseRow = expenseRows.single;
      expect(expenseRow.id, 1);
      expect(expenseRow.title, expense.title);
      expect(expenseRow.description, expense.description);
      expect(expenseRow.createdAt, expense.createdAt);
      expect(expenseRow.updatedAt, expense.updatedAt);

      expect(expenseTagsRows, hasLength(2));
      expect(expenseTagsRows[0].expenseId, 1);
      expect(expenseTagsRows[0].tagId, 1);
      expect(expenseTagsRows[1].expenseId, 1);
      expect(expenseTagsRows[1].tagId, 2);

      expect(installmentRows, hasLength(2));
      expect(installmentRows[0].id, 1);
      expect(installmentRows[0].expenseId, 1);
      expect(installmentRows[0].valueCents, 3500);
      expect(installmentRows[0].index, 0);
      expect(installmentRows[0].date, DateTime(2024, 10, 3));
      expect(installmentRows[1].id, 2);
      expect(installmentRows[1].expenseId, 1);
      expect(installmentRows[1].valueCents, 4000);
      expect(installmentRows[1].index, 1);
      expect(installmentRows[1].date, DateTime(2024, 11, 3));

      expect(personPartRows, hasLength(2));
      expect(personPartRows[0].id, 1);
      expect(personPartRows[0].installmentId, 1);
      expect(personPartRows[0].name, 'Pessoa 1');
      expect(personPartRows[0].valueCents, 1500);
      expect(personPartRows[1].id, 2);
      expect(personPartRows[1].installmentId, 2);
      expect(personPartRows[1].name, 'Pessoa 1');
      expect(personPartRows[1].valueCents, 1000);
    });
  });

  group('Pending payments', () {
    test('when database is empty', () {
      final stream = db.watchPendingPayments(DateTime.now());

      expect(stream, emits(isEmpty));
    });

    test('should return all people', () async {
      final expense = expenseFix.expenseWithPeople;
      await db.addExpense(expense);

      final date = expense.installments!.single.date.monthYear.lastDay;

      final stream = db.watchPendingPayments(date);
      expect(
          stream,
          emits(unorderedEquals([
            PendingPayment(name: 'Pessoa 1', value: MoneyUtils.fromCents(1000)),
            PendingPayment(name: 'Pessoa 2', value: MoneyUtils.fromCents(1500)),
          ])));
    });

    test('should sum and ignore installments after date', () async {
      final expense = expenseFix.expenseWithPersonMultipleTimes;
      expense.tags!.clear();
      await db.addExpense(expense);

      final date = expense.installments![1].date.monthYear.lastDay;

      final stream = db.watchPendingPayments(date);
      expect(
          stream,
          emits(unorderedEquals([
            PendingPayment(name: 'Pessoa 1', value: MoneyUtils.fromCents(2000)),
          ])));
    });
  });
}
