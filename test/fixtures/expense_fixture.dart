import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/models/installment_model.dart';
import 'package:xpenses/models/person_part_model.dart';
import 'package:xpenses/utils/money_utils.dart';

import 'tag_fixture.dart';

class ExpenseFixture {
  final _tagFix = TagFixture();
  late final expense1 = Expense(
    id: 0,
    title: 'Compra 1',
    description: 'Descrição da compra 1',
    createdAt: DateTime(2024, 10, 5),
    updatedAt: DateTime(2024, 10, 5),
    installments: [
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(3500),
        date: DateTime(2024, 10, 3),
        index: 0,
        personParts: [],
        expense: null,
      ),
    ],
    tags: [],
  );

  late final expense2 = Expense(
    id: 0,
    title: 'Compra 2',
    description: 'Descrição da compra 2',
    createdAt: DateTime(2024, 9, 7),
    updatedAt: DateTime(2024, 9, 7),
    installments: [
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(4200),
        date: DateTime(2024, 9, 3),
        index: 0,
        personParts: [],
        expense: null,
      ),
    ],
    tags: [],
  );

  late final expenseWithTags = Expense(
    id: 0,
    title: 'Compra 1',
    description: 'Descrição da compra 1',
    createdAt: DateTime(2024, 10, 5),
    updatedAt: DateTime(2024, 10, 5),
    installments: [
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(3500),
        date: DateTime(2024, 10, 3),
        index: 0,
        personParts: [],
        expense: null,
      ),
    ],
    tags: [
      _tagFix.tag1.copyWithId(1),
      _tagFix.tag2.copyWithId(2),
    ],
  );

  late final expenseWithPeople = Expense(
    id: 0,
    title: 'Compra 1',
    description: 'Descrição da compra 1',
    createdAt: DateTime(2024, 10, 5),
    updatedAt: DateTime(2024, 10, 5),
    installments: [
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(3500),
        date: DateTime(2024, 10, 3),
        index: 0,
        personParts: [
          PersonPart(
            id: 0,
            value: MoneyUtils.fromCents(1000),
            name: 'Pessoa 1',
          ),
          PersonPart(
            id: 0,
            value: MoneyUtils.fromCents(1500),
            name: 'Pessoa 2',
          ),
        ],
        expense: null,
      ),
    ],
    tags: [],
  );

  late final expenseWithPersonMultipleTimes = Expense(
    id: 0,
    title: 'Compra 1',
    description: 'Descrição da compra 1',
    createdAt: DateTime(2024, 10, 5),
    updatedAt: DateTime(2024, 10, 5),
    installments: [
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(3500),
        date: DateTime(2024, 10, 3),
        index: 0,
        personParts: [
          PersonPart(
            id: 0,
            value: MoneyUtils.fromCents(1000),
            name: 'Pessoa 1',
          ),
        ],
        expense: null,
      ),
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(3500),
        date: DateTime(2024, 11, 3),
        index: 1,
        personParts: [
          PersonPart(
            id: 0,
            value: MoneyUtils.fromCents(1000),
            name: 'Pessoa 1',
          ),
        ],
        expense: null,
      ),
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(3500),
        date: DateTime(2024, 12, 3),
        index: 2,
        personParts: [
          PersonPart(
            id: 0,
            value: MoneyUtils.fromCents(1000),
            name: 'Pessoa 1',
          ),
        ],
        expense: null,
      ),
    ],
    tags: [],
  );

  late final expenseWithInstallments = Expense(
    id: 0,
    title: 'Compra 1',
    description: 'Descrição da compra 1',
    createdAt: DateTime(2024, 10, 5),
    updatedAt: DateTime(2024, 10, 5),
    installments: [
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(3500),
        date: DateTime(2024, 10, 3),
        index: 0,
        personParts: [],
        expense: null,
      ),
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(4000),
        date: DateTime(2024, 11, 3),
        index: 1,
        personParts: [],
        expense: null,
      ),
    ],
    tags: [],
  );

  late final expenseComplete = Expense(
    id: 0,
    title: 'Compra 1',
    description: 'Descrição da compra 1',
    createdAt: DateTime(2024, 10, 5),
    updatedAt: DateTime(2024, 10, 5),
    installments: [
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(3500),
        date: DateTime(2024, 10, 3),
        index: 0,
        personParts: [
          PersonPart(
            id: 0,
            value: MoneyUtils.fromCents(1500),
            name: 'Pessoa 1',
          ),
        ],
        expense: null,
      ),
      Installment(
        id: 0,
        value: MoneyUtils.fromCents(4000),
        date: DateTime(2024, 11, 3),
        index: 1,
        personParts: [
          PersonPart(
            id: 0,
            value: MoneyUtils.fromCents(1000),
            name: 'Pessoa 1',
          ),
        ],
        expense: null,
      ),
    ],
    tags: [
      _tagFix.tag1.copyWithId(1),
      _tagFix.tag2.copyWithId(2),
    ],
  );
}
