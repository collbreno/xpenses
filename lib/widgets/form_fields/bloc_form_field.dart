import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/bloc/entity_form_cubit.dart';
import 'package:xpenses/enums/form_field_enum.dart';

class BlocFormField<Field, Entity> extends StatelessWidget {
  final FormFieldEnum field;
  final FormFieldBuilder<Field> builder;
  final AutovalidateMode? autovalidateMode;
  final String? Function(Field?)? validator;
  final Field? initialValue;
  final bool enabled;
  const BlocFormField({
    super.key,
    required this.field,
    required this.builder,
    this.enabled = true,
    this.autovalidateMode,
    this.validator,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<Field>(
      builder: builder,
      autovalidateMode: autovalidateMode,
      validator: validator,
      initialValue: initialValue,
      enabled: enabled,
      onSaved: (value) {
        context.read<EntityFormCubit<Entity>>().saveField(
              field,
              value,
            );
      },
    );
  }
}
