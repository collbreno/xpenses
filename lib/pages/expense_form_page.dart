import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/bloc/entity_form_cubit.dart';
import 'package:xpenses/entities/expense_entity.dart';
import 'package:xpenses/enums/form_field_enum.dart';
import 'package:xpenses/pages/entity_form.dart';
import 'package:xpenses/widgets/form_fields/date_form_field.dart';
import 'package:xpenses/widgets/form_fields/tags_form_field.dart';
import 'package:xpenses/widgets/form_fields/string_form_field.dart';
import 'package:xpenses/widgets/form_fields/value_form_field.dart';

class NewExpensePage extends StatelessWidget {
  const NewExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return EntityForm<Expense>(
      appbar: AppBar(title: const Text('Novo Gasto')),
      formFields: [
        ValueFormField(
          initialValue: null,
          onSaved: (value) {
            context.read<EntityFormCubit<Expense>>().saveField(
                  FormFieldEnum.expenseValue,
                  value,
                );
          },
        ),
        DateFormField(
          initialValue: DateTime.now(),
          onSaved: (value) {
            context.read<EntityFormCubit<Expense>>().saveField(
                  FormFieldEnum.expenseDate,
                  value,
                );
          },
        ),
        StringFormField(
          maxLines: 3,
          initialValue: '',
          onSaved: (value) {
            context.read<EntityFormCubit<Expense>>().saveField(
                  FormFieldEnum.expenseDescription,
                  value,
                );
          },
        ),
        TagsFormField(
          initialValue: const {},
          onSaved: (value) {
            context.read<EntityFormCubit<Expense>>().saveField(
                  FormFieldEnum.expenseTags,
                  value,
                );
          },
        ),
      ],
    );
  }
}
