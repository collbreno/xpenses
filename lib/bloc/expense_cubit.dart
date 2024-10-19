import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/database/i_database.dart';
import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/utils/async_data.dart';

class ExpenseCubit extends Cubit<AsyncData<Expense>> {
  final IAppDatabase db;
  final int id;
  late final StreamSubscription _sub;

  ExpenseCubit({
    required this.db,
    required this.id,
  }) : super(const AsyncData.nothing());

  void load() {
    emit(const AsyncData.loading());
    _sub = db.watchExpense(id).listen(
          (expense) => emit(AsyncData.withData(expense)),
          onError: (error) => emit(AsyncData.withError(error)),
        );
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
