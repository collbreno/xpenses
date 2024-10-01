import 'package:money2/money2.dart';
import 'package:xpenses/constants.dart';

abstract class MoneyUtils {
  static final zero = Money.fromIntWithCurrency(0, Constants.currency);
}
