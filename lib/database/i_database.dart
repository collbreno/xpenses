import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/models/installment_model.dart';
import 'package:xpenses/models/pending_payment.dart';
import 'package:xpenses/models/tag_model.dart';
import 'package:xpenses/utils/month.dart';

abstract class IAppDatabase {
  Future<List<Tag>> getAllTags();
  Future<int> addTag(Tag model);
  Future<bool> updateTag(Tag model);
  Future<List<Installment>> getInstallments(Month month);
  Stream<Money> watchTotalByMonth(Month month);
  Future<int> addExpense(Expense model);
  Future<DateTimeRange> getExpensesDateTimeRange();
  Stream<List<PendingPayment>> watchPendingPayments(DateTime until);
  Stream<Expense> watchExpense(int id);
}
