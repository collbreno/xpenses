import 'package:equatable/equatable.dart';
import 'package:money2/money2.dart';

class PendingPayment extends Equatable {
  final String name;
  final Money value;

  const PendingPayment({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [
        name,
        value,
      ];
}
