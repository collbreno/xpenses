import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money2/money2.dart';
import 'package:objectbox/objectbox.dart';
import 'package:xpenses/entities/expense_entity.dart';
import 'package:xpenses/pages/entity_form.dart';
import 'package:xpenses/widgets/form_fields/date_form_field.dart';
import 'package:xpenses/widgets/form_fields/installments_form_field.dart';
import 'package:xpenses/widgets/form_fields/people_form_field.dart';
import 'package:xpenses/widgets/form_fields/tags_form_field.dart';
import 'package:xpenses/widgets/form_fields/string_form_field.dart';
import 'package:xpenses/widgets/form_fields/value_form_field.dart';

class ExpenseFormPage extends StatefulWidget {
  final Expense? expense;
  final VoidCallback onSaved;
  const ExpenseFormPage({
    super.key,
    this.expense,
    required this.onSaved,
  });

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  late final Expense _expense;
  late Money _previewTotalValue;

  @override
  void initState() {
    super.initState();
    _expense = widget.expense ??
        Expense(
          description: '',
          date: DateTime.now(),
        );
    _previewTotalValue = _expense.value;
  }

  @override
  Widget build(BuildContext context) {
    return EntityForm(
      appbarTitle: const Text('Novo Gasto'),
      onSave: () async {
        await context.read<Box<Expense>>().putAsync(_expense);
        widget.onSaved();
      },
      onDelete: widget.expense == null
          ? null
          : () async {
              await context
                  .read<Box<Expense>>()
                  .removeAsync(widget.expense!.id);
              widget.onSaved();
            },
      formFields: [
        ValueFormField(
          initialValue: _expense.value,
          onSaved: (value) => setState(() {
            _expense.value = value!;
          }),
          onChanged: (value) => setState(() {
            _previewTotalValue = value!;
          }),
        ),
        DateFormField(
          initialValue: _expense.date,
          onSaved: (value) => setState(() {
            _expense.date = value!;
          }),
        ),
        StringFormField(
          maxLines: 3,
          icon: const Icon(Icons.edit),
          hint: 'Insira a descrição',
          label: 'Descrição',
          initialValue: _expense.description,
          onSaved: (value) => setState(() {
            _expense.description = value!;
          }),
        ),
        TagsFormField(
          initialValue: _expense.tags.toSet(),
          onSaved: (value) => setState(() {
            _expense.tags.clear();
            _expense.tags.addAll(value!);
          }),
        ),
        InstallmentsFormField(
          totalValue: _previewTotalValue,
          initialValue: 1,
        ),
        PeopleFormField(
          totalValue: _previewTotalValue,
          initialValue: const {},
        ),
      ],
    );
  }
}
