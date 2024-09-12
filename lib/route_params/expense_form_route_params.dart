import 'package:flutter/material.dart';
import 'package:xpenses/entities/expense_entity.dart';

class ExpenseFormRouteParams {
  final Expense? expense;
  final VoidCallback onSaved;

  ExpenseFormRouteParams({
    required this.expense,
    required this.onSaved,
  });
}
