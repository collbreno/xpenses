import 'package:flutter/material.dart';
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
        ValueFormField<Expense>(
          initialValue: null,
          field: FormFieldEnum.expenseValue,
        ),
        DateFormField<Expense>(
          initialValue: DateTime.now(),
          field: FormFieldEnum.expenseDate,
        ),
        StringFormField<Expense>(
          maxLines: 3,
          initialValue: '',
          field: FormFieldEnum.expenseDescription,
        ),
        TagsFormField<Expense>(
          initialValue: const {},
          field: FormFieldEnum.expenseTags,
        ),
      ],
    );
  }
}
