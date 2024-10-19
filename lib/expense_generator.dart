import 'package:collection/collection.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/models/installment_model.dart';
import 'package:xpenses/models/person_part_model.dart';
import 'package:xpenses/models/tag_model.dart';
import 'package:xpenses/utils/money_utils.dart';

class ExpenseGenerator {
  int id;
  String title;
  String description;
  DateTime date;
  DateTime createdAt;
  DateTime updatedAt;
  Money value;
  int nInstallments;
  List<Tag> tags;
  List<PersonPart> personParts;

  ExpenseGenerator()
      : id = 0,
        title = '',
        description = '',
        date = DateTime.now(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        value = MoneyUtils.zero,
        nInstallments = 1,
        tags = [],
        personParts = [];

  ExpenseGenerator.fromExpense(Expense expense)
      : id = expense.id,
        title = expense.title,
        description = expense.description,
        date = expense.firstDate!,
        createdAt = expense.createdAt,
        updatedAt = DateTime.now(),
        value = expense.totalValue!,
        nInstallments = expense.installments!.length,
        tags = expense.tags!,
        personParts = expense.installments!
            .fold(<PersonPart>[], (acc, e) => acc + e.personParts)
            .groupListsBy((e) => e.name)
            .entries
            .map((entry) => PersonPart(
                  id: 0,
                  value: entry.value
                      .fold(MoneyUtils.zero, (acc, e) => acc + e.value),
                  name: entry.key,
                ))
            .toList();

  Expense generate() {
    final installments = List.generate(nInstallments, (index) {
      return Installment(
        id: 0,
        value: value / nInstallments,
        date: DateTime(date.year, date.month + index, date.day),
        index: index,
        personParts: personParts
            .map((e) => e.copy(value: e.value / nInstallments))
            .toList(),
        expense: null,
      );
    });

    return Expense(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      installments: installments,
      tags: tags,
    );
  }
}
