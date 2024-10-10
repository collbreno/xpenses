import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/database/i_database.dart';
import 'package:xpenses/models/installment_model.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/utils/month.dart';

part 'installments_state.dart';

class InstallmentsCubit extends Cubit<InstallmentsState> {
  final IAppDatabase db;
  InstallmentsCubit(this.db) : super(const InstallmentsState.initial());

  Future<void> loadRange() async {
    emit(state.copy(range: const AsyncData.loading()));
    try {
      final range = await db.getExpensesDateTimeRange();
      emit(state.copy(range: AsyncData.withData(range)));
    } catch (e) {
      emit(state.copy(range: AsyncData.withError(e)));
      rethrow;
    }
  }

  Future<void> loadMonth(Month month) async {
    if (state.getByMonth(month).isLoading) return;
    final map = Map.of(state.byMonth);
    map[month] = const AsyncData.loading();
    emit(state.copy(byMonth: map));
    try {
      final list = await db.getInstallments(month);
      map[month] = AsyncData.withData(list);
      emit(state.copy(byMonth: map));
    } catch (e) {
      map[month] = AsyncData.withError(e);
      emit(state.copy(byMonth: map));
      rethrow;
    }
  }
}
