import 'package:flutter/material.dart';

class StringFormField extends FormField<String> {
  StringFormField({
    super.onSaved,
    super.initialValue,
    super.key,
    ValueChanged<String?>? onChanged,
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
                title: TextFormField(
                  maxLines: maxLines,
                  minLines: 1,
                  initialValue: initialValue,
                  onChanged: (value) {
                    state.didChange(value);
                    onChanged?.call(value);
                  },
                  onSaved: (a) {
                    print('[onSaved] $a');
                    onSaved!(a);
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
