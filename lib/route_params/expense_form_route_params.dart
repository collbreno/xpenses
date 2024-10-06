import 'package:flutter/material.dart';
import 'package:xpenses/models/expense_model.dart';

class ExpenseFormRouteParams {
  final Expense? expense;
  final VoidCallback onSaved;

  ExpenseFormRouteParams({
    required this.expense,
    required this.onSaved,
  });
}
