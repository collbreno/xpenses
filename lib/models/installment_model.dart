import 'package:money2/money2.dart';
import 'package:xpenses/constants.dart';
import 'package:xpenses/database/database.dart';
import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/models/person_part_model.dart';
import 'package:xpenses/utils/money_utils.dart';

class Installment {
  final int id;
  final Money value;
  final DateTime date;
  final int index;
  final List<PersonPart> personParts;
  final Expense? expense;
  final int? totalCount;

  Money get myPart =>
      value - personParts.fold(MoneyUtils.zero, (acc, e) => acc + e.value);

  Installment({
    required this.id,
    required this.value,
    required this.date,
    required this.index,
    required this.personParts,
    required this.expense,
    this.totalCount,
  });

  Installment.fromTable(
    InstallmentEntry entry, {
    required Iterable<PersonPartEntry> personPartEntries,
    ExpenseEntry? expenseEntry,
    this.totalCount,
  })  : id = entry.id,
        value = Money.fromIntWithCurrency(entry.valueCents, Constants.currency),
        date = entry.date,
        index = entry.index,
        personParts = personPartEntries.map(PersonPart.fromTable).toList(),
        expense = expenseEntry != null
            ? Expense.fromTable(expenseEntry, tagEntries: [])
            : null;
}
