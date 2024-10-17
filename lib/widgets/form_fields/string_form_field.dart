import 'package:flutter/material.dart';

class StringFormField extends FormField<String> {
  StringFormField({
    super.onSaved,
    super.initialValue,
    super.key,
    ValueChanged<String?>? onChanged,
    String? hint,
    String? label,
    Widget? icon,
    int maxLines = 1,
    super.validator,
  }) : super(
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
                    onSaved!(a);
                  },
                  decoration: InputDecoration(
                    icon: icon,
                    border: const OutlineInputBorder(),
                    hintText: hint,
                    labelText: label,
                    errorText: state.errorText,
                  ),
                ),
              );
            });
          },
        );
}
