import 'package:money2/money2.dart';
import 'package:xpenses/constants.dart';
import 'package:xpenses/database/database.dart';
import 'package:xpenses/utils/money_utils.dart';

class PersonPart {
  final int id;
  final Money value;
  final String name;

  PersonPart({
    required this.id,
    required this.value,
    required this.name,
  });

  PersonPart.create(this.name)
      : id = 0,
        value = MoneyUtils.zero;

  PersonPart copy({
    Money? value,
    String? name,
  }) =>
      PersonPart(
        id: id,
        value: value ?? this.value,
        name: name ?? this.name,
      );

  PersonPart.fromTable(PersonPartEntry entry)
      : id = entry.id,
        value = Money.fromIntWithCurrency(entry.valueCents, Constants.currency),
        name = entry.name;
}
