part of 'installments_cubit.dart';

class InstallmentsState extends Equatable {
  final AsyncData<DateTimeRange> range;
  final Map<Month, AsyncData<List<Installment>>> byMonth;
  const InstallmentsState.initial()
      : range = const AsyncData.nothing(),
        byMonth = const {};

  const InstallmentsState._({
    required this.range,
    required this.byMonth,
  });

  InstallmentsState copy({
    AsyncData<DateTimeRange>? range,
    Map<Month, AsyncData<List<Installment>>>? byMonth,
  }) =>
      InstallmentsState._(
        range: range ?? this.range,
        byMonth: byMonth ?? this.byMonth,
      );

  AsyncData<List<Installment>> getByMonth(Month month) {
    return byMonth.containsKey(month)
        ? byMonth[month]!
        : const AsyncData.nothing();
  }

  List<Month>? get months {
    if (range.hasData) {
      return range.data!.start.monthYear
          .rangeTo(range.data!.end.monthYear)
          .toList();
    }
    return null;
  }

  @override
  List<Object?> get props => [range, byMonth];
}
