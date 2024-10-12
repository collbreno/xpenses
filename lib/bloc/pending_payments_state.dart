part of 'pending_payments_cubit.dart';

class PendingPaymentsState extends Equatable {
  final AsyncData<List<PendingPayment>> list;

  const PendingPaymentsState.initial() : list = const AsyncData.nothing();

  const PendingPaymentsState._({
    required this.list,
  });

  PendingPaymentsState copy({
    AsyncData<List<PendingPayment>>? list,
  }) =>
      PendingPaymentsState._(
        list: list ?? this.list,
      );

  @override
  List<Object?> get props => [
        list,
      ];
}
