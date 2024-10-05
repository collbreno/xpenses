import 'package:objectbox/objectbox.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/entities/installment_entity.dart';
import 'package:xpenses/entities/tag_entity.dart';
import 'package:xpenses/utils/money_utils.dart';

@Entity()
class Expense {
  int id = 0;

  String title;
  String description;

  @Transient()
  Money get totalValue =>
      installments.fold(MoneyUtils.zero, (acc, e) => acc + e.value);

  set totalValue(Money value) {
    if (installments.isNotEmpty) {
      final n = installments.length;
      for (final installment in installments) {
        installment.value = value / n;
      }
    } else {
      installments.add(Installment(
        date: date,
        number: 0,
        value: value,
      ));
    }
  }

  int get nInstallments => installments.length;
  set nInstallments(int n) {
    final totalValue = this.totalValue;
    installments.clear();
    for (var i = 0; i < n; i++) {
      installments.add(Installment(
        date: DateTime(date.year, date.month + i, date.day),
        value: totalValue / n,
        number: i,
      ));
    }
  }

  @Transient()
  Money get myPartTotal =>
      installments.fold(MoneyUtils.zero, (acc, e) => acc + e.myPart);

  @Property(type: PropertyType.date)
  DateTime date;

  final tags = ToMany<Tag>();
  @Backlink('expense')
  final installments = ToMany<Installment>();

  Expense({
    required this.title,
    required this.description,
    required this.date,
  });
}
