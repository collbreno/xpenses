import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/utils/focus_utils.dart';
import 'package:xpenses/widgets/calculator.dart';

class ValueFormField extends FormField<Money> {
  ValueFormField({
    super.key,
    super.initialValue,
    super.onSaved,
    ValueChanged<Money?>? onChanged,
  }) : super(
          validator: (value) {
            if (value == null) return 'Não pode ser vazio';
            if (value.isNegative) return 'Não pode ser menor que zero';
            if (value.isZero) return 'Não pode ser igual a zero';
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (state) {
            return Builder(builder: (context) {
              return ListTile(
                leading: const Icon(Icons.attach_money),
                title: InkWell(
                  onTap: () async {
                    FocusUtils.unfocus();
                    final result = await showCalculator(context);
                    if (result != null) {
                      state.didChange(result);
                      onChanged?.call(result);
                    }
                  },
                  child: InputDecorator(
                    isEmpty: state.value == null,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Insira o valor',
                      labelText: 'Valor',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      errorText: state.errorText,
                    ),
                    child: state.value == null
                        ? null
                        : Text(
                            state.value.toString(),
                          ),
                  ),
                ),
              );
            });
          },
        );
}
