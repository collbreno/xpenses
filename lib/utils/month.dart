import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Month extends Equatable {
  final int year;
  final int monthNumber;

  const Month(this.year, this.monthNumber);
  Month.fromDateTime(DateTime date)
      : year = date.year,
        monthNumber = date.month;

  Month get prev => Month.fromDateTime(DateTime(year, monthNumber - 1));
  Month get next => Month.fromDateTime(DateTime(year, monthNumber + 1));

  DateTime get firstDay => DateTime(year, monthNumber, 1);
  DateTime get lastDay => DateTime(year, monthNumber + 1, 0);

  Iterable<Month> rangeTo(Month other) sync* {
    for (var period = this; period.isBefore(other.next); period = period.next) {
      yield period;
    }
  }

  bool isBefore(Month other) {
    return year < other.year ||
        (year == other.year && monthNumber < other.monthNumber);
  }

  String format() {
    final omitYear = year == DateTime.now().year;
    return DateFormat(omitYear ? 'MMMM' : 'MMM/yy').format(firstDay);
  }

  @override
  List<Object?> get props => [year, monthNumber];
}

extension MonthExt on DateTime {
  Month get monthYear => Month.fromDateTime(this);
}
