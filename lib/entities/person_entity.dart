import 'package:money2/money2.dart';
import 'package:objectbox/objectbox.dart';
import 'package:xpenses/constants.dart';
import 'package:xpenses/entities/installment_entity.dart';
import 'package:xpenses/utils/money_utils.dart';

@Entity()
class PersonPart {
  int id = 0;

  @Transient()
  Money value;
  int get cents => value.minorUnits.toInt();
  set cents(int cents) =>
      value = Money.fromIntWithCurrency(cents, Constants.currency);

  String name;
  bool isPaid;

  final installment = ToOne<Installment>();

  PersonPart({
    required this.name,
    required this.isPaid,
    Money? value,
  }) : value = value ?? MoneyUtils.zero;
}
