import 'package:intl/intl.dart';

extension DateTimeUtilsExt on DateTime {
  String formatDMY() => DateFormat('dd/MM/yy').format(this);
}
