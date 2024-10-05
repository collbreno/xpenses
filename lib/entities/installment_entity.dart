import 'package:objectbox/objectbox.dart';
import 'package:xpenses/constants.dart';
import 'package:xpenses/entities/expense_entity.dart';
import 'package:xpenses/entities/person_entity.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/utils/money_utils.dart';

@Entity()
class Installment {
  int id = 0;

  @Transient()
  Money value;
  int get cents => value.minorUnits.toInt();
  set cents(int cents) =>
      value = Money.fromIntWithCurrency(cents, Constants.currency);

  @Property(type: PropertyType.date)
  DateTime date;

  int number;

  final expense = ToOne<Expense>();
  @Backlink()
  final people = ToMany<PersonPart>();

  @Transient()
  Money get myPart =>
      value - people.fold(MoneyUtils.zero, (acc, e) => acc + e.value);

  Installment({
    required this.date,
    required this.number,
    Money? value,
  }) : value = value ?? MoneyUtils.zero;
}
