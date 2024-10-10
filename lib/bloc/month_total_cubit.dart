import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/database/i_database.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/utils/month.dart';

part 'month_total_state.dart';

class MonthTotalCubit extends Cubit<MonthTotalState> {
  final IAppDatabase db;
  MonthTotalCubit(this.db) : super(const MonthTotalState.initial());

  late final StreamSubscription<Money> _thisMonthSub;
  late final StreamSubscription<Money> _prevMonthSub;

  void load() {
    _loadThisMonth();
    _loadPrevMonth();
  }

  void _loadThisMonth() async {
    emit(state.copy(thisMonth: const AsyncData.loading()));
    _thisMonthSub = db.watchTotalByMonth(DateTime.now().monthYear).listen(
      (value) {
        emit(state.copy(thisMonth: AsyncData.withData(value)));
      },
      onError: (e) {
        emit(state.copy(thisMonth: AsyncData.withError(e)));
      },
    );
  }

  void _loadPrevMonth() async {
    emit(state.copy(prevMonth: const AsyncData.loading()));
    _prevMonthSub = db.watchTotalByMonth(DateTime.now().monthYear.prev).listen(
      (value) {
        emit(state.copy(prevMonth: AsyncData.withData(value)));
      },
      onError: (e) {
        emit(state.copy(prevMonth: AsyncData.withError(e)));
      },
    );
  }

  @override
  Future<void> close() {
    _prevMonthSub.cancel();
    _thisMonthSub.cancel();
    return super.close();
  }
}
