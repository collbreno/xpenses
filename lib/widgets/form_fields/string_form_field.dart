import 'package:flutter/material.dart';
import 'package:xpenses/widgets/form_fields/bloc_form_field.dart';

class StringFormField<Entity> extends BlocFormField<String, Entity> {
  StringFormField({
    super.key,
    required super.field,
    super.initialValue,
    ValueChanged<String>? onChanged,
    int maxLines = 1,
  }) : super(
          validator: (value) {
            if (value == null || value.isEmpty) return 'Não pode ser vazio';
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (state) {
            return Builder(builder: (context) {
              return ListTile(
                title: TextField(
                  maxLines: maxLines,
                  minLines: 1,
                  onChanged: (value) {
                    state.didChange(value);
                    onChanged?.call(value);
                  },
                  decoration: InputDecoration(
                    icon: const Icon(Icons.edit),
                    border: const OutlineInputBorder(),
                    hintText: 'Insira a descrição',
                    labelText: 'Descrição',
                    errorText: state.errorText,
                  ),
                ),
              );
            });
          },
        );
}
