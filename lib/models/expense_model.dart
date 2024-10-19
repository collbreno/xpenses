import 'package:money2/money2.dart';
import 'package:xpenses/database/database.dart';
import 'package:xpenses/models/installment_model.dart';
import 'package:xpenses/models/tag_model.dart';
import 'package:xpenses/utils/money_utils.dart';

class Expense {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Installment>? installments;
  final List<Tag>? tags;

  DateTime? get firstDate => installments?.first.date;
  Money? get totalValue =>
      installments?.fold(MoneyUtils.zero, (acc, e) => acc! + e.value);
  Money? get myPart =>
      installments?.fold(MoneyUtils.zero, (acc, e) => acc! + e.myPart);

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.installments,
    required this.tags,
  });

  Expense.fromTable(
    ExpenseEntry entry, {
    this.tags,
    this.installments,
  })  : id = entry.id,
        title = entry.title,
        description = entry.description,
        createdAt = entry.createdAt,
        updatedAt = entry.updatedAt;
}
