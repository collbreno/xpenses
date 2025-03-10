import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/enums/division_type.dart';
import 'package:xpenses/models/person_part_model.dart';
import 'package:xpenses/utils/focus_utils.dart';
import 'package:xpenses/utils/money_utils.dart';
import 'package:xpenses/widgets/calculator.dart';
import 'package:xpenses/widgets/input_dialog.dart';

class PeopleFormField extends FormField<Iterable<PersonPart>> {
  PeopleFormField({
    super.key,
    required Money totalValue,
    super.initialValue,
    super.onSaved,
  }) : super(
          builder: (state) {
            return Builder(
              builder: (context) {
                final list = state.value!;
                return Column(
                  children: [
                    ListTile(
                      title: Text('${list.length} Pessoas'),
                      leading: const Icon(Icons.people),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (list.isNotEmpty)
                            _buildSplitButton(context, totalValue, state),
                          _buildAddButton(context, state),
                        ],
                      ),
                    ),
                    if (list.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 6,
                        ),
                        child: Column(
                          children: [
                            _buildSelf(totalValue, list),
                            ...list.mapIndexed(
                              (index, person) => _buildPerson(
                                context,
                                person,
                                index,
                                state,
                              ),
                            )
                          ],
                        ),
                      )
                  ],
                );
              },
            );
          },
        );

  static ListTile _buildPerson(
    BuildContext context,
    PersonPart person,
    int index,
    FormFieldState<Iterable<PersonPart>> state,
  ) {
    final list = state.value!;
    return ListTile(
      dense: true,
      title: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                FocusUtils.unfocus();
                final name = await showInputDialog(
                  context: context,
                  title: 'Insira o nome',
                  initialValue: person.name,
                );

                if (name != null) {
                  final newList = list.toList();
                  newList[index] = person.copy(name: name);
                  state.didChange(newList);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                child: Text(person.name),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () async {
                FocusUtils.unfocus();
                final newValue = await showCalculator(context);
                if (newValue != null) {
                  final newList = list.toList();
                  newList[index] = person.copy(value: newValue);
                  state.didChange(newList);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  person.value.toString(),
                ),
              ),
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: () {
          FocusUtils.unfocus();
          final newList = list.toList();
          newList.removeAt(index);
          state.didChange(newList);
        },
      ),
    );
  }

  static ListTile _buildSelf(Money totalValue, Iterable<PersonPart> list) {
    final value = totalValue -
        (list.fold(MoneyUtils.zero, (acc, val) => acc + val.value));
    return ListTile(
      dense: true,
      title: Row(
        children: [
          const Expanded(flex: 3, child: Text('Você')),
          Expanded(
            flex: 2,
            child: Text(
              value.toString(),
            ),
          ),
        ],
      ),
      trailing: const IconButton(
        icon: Icon(
          Icons.abc,
          color: Colors.transparent,
        ),
        onPressed: null,
      ),
    );
  }

  static IconButton _buildAddButton(
    BuildContext context,
    FormFieldState<Iterable<PersonPart>> state,
  ) {
    return IconButton(
      key: const ValueKey('add_button'),
      onPressed: () async {
        FocusUtils.unfocus();
        final name = await showInputDialog(
          context: context,
          title: 'Insira o nome',
        );
        if (name != null) {
          final newList = state.value!.toList();
          newList.add(PersonPart.create(name));
          state.didChange(newList);
        }
      },
      icon: const Icon(Icons.add),
    );
  }

  static IconButton _buildSplitButton(
    BuildContext context,
    Money totalValue,
    FormFieldState<Iterable<PersonPart>> state,
  ) {
    final list = state.value!;
    return IconButton(
      onPressed: () async {
        FocusUtils.unfocus();
        final divisionType = await _showDivisionDialog(context);
        if (divisionType != null) {
          final count = divisionType == DivisionType.includeMe
              ? list.length + 1
              : list.length;
          final newList = list.map((person) => person.copy(
                value: totalValue / count,
              ));
          state.didChange(newList);
        }
      },
      icon: const Icon(Icons.splitscreen),
    );
  }
}

Future<DivisionType?> _showDivisionDialog(BuildContext context) {
  return showDialog<DivisionType>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Dividir igualmente'),
        content: const Text('Como deseja dividir a conta entre as pessoas?'),
        actions: [
          ...DivisionType.values.map(
            (e) => TextButton(
              onPressed: () => context.pop(e),
              child: Text(e.text),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}
