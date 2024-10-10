part of 'month_total_cubit.dart';

class MonthTotalState extends Equatable {
  final AsyncData<Money> thisMonth;
  final AsyncData<Money> prevMonth;

  const MonthTotalState.initial()
      : thisMonth = const AsyncData.nothing(),
        prevMonth = const AsyncData.nothing();

  const MonthTotalState._({
    required this.thisMonth,
    required this.prevMonth,
  });

  MonthTotalState copy({
    AsyncData<Money>? thisMonth,
    AsyncData<Money>? prevMonth,
  }) =>
      MonthTotalState._(
        thisMonth: thisMonth ?? this.thisMonth,
        prevMonth: prevMonth ?? this.prevMonth,
      );

  @override
  List<Object?> get props => [
        thisMonth,
        prevMonth,
      ];
}
