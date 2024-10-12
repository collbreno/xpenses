import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/database/i_database.dart';
import 'package:xpenses/models/pending_payment.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/utils/month.dart';

part 'pending_payments_state.dart';

class PendingPaymentsCubit extends Cubit<PendingPaymentsState> {
  final IAppDatabase db;
  PendingPaymentsCubit(this.db) : super(const PendingPaymentsState.initial());

  late final StreamSubscription<List<PendingPayment>> _sub;

  void load() {
    emit(state.copy(list: const AsyncData.loading()));
    _sub = db.watchPendingPayments(DateTime.now().monthYear.lastDay).listen(
      (value) {
        emit(state.copy(list: AsyncData.withData(value)));
      },
      onError: (e) {
        emit(state.copy(list: AsyncData.withError(e)));
        throw e;
      },
    );
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
