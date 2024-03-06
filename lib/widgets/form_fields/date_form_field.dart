import 'package:flutter/material.dart';
import 'package:xpenses/constants.dart';

class DateFormField extends FormField<DateTime> {
  DateFormField({
    super.key,
    super.initialValue,
    super.onSaved,
    ValueChanged<DateTime>? onChanged,
  }) : super(
          validator: (value) {
            if (value == null) return 'Não pode ser vazio';
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (state) {
            return Builder(builder: (context) {
              return ListTile(
                onTap: () async {
                  final result = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );

                  if (result != null) {
                    state.didChange(result);
                    onChanged?.call(result);
                  }
                },
                title: InputDecorator(
                  isEmpty: state.value == null,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(),
                    hintText: 'Insira a data',
                    labelText: 'Data',
                    errorText: state.errorText,
                  ),
                  child: state.value == null
                      ? null
                      : Text(
                          Constants.dateFormat.format(state.value!),
                        ),
                ),
              );
            });
          },
        );
}
