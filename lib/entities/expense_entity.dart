import 'package:objectbox/objectbox.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/constants.dart';
import 'package:xpenses/entities/tag_entity.dart';

@Entity()
class Expense {
  int id = 0;

  String description;

  @Transient()
  Money value;
  int get cents => value.minorUnits.toInt();
  set cents(int cents) =>
      value = Money.fromIntWithCurrency(cents, Constants.currency);

  @Property(type: PropertyType.date)
  DateTime date;

  final tags = ToMany<Tag>();

  Expense({
    required this.description,
    required this.date,
    Money? value,
  }) : value = value ?? Money.fromIntWithCurrency(0, Constants.currency);
}
