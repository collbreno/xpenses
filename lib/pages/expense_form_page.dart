import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:objectbox/objectbox.dart';
import 'package:xpenses/entities/expense_entity.dart';
import 'package:xpenses/pages/entity_form.dart';
import 'package:xpenses/widgets/form_fields/date_form_field.dart';
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

  @override
  void initState() {
    super.initState();
    _expense = widget.expense ??
        Expense(
          description: '',
          date: DateTime.now(),
        );
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
        ),
        DateFormField(
          initialValue: _expense.date,
          onSaved: (value) => setState(() {
            _expense.date = value!;
          }),
        ),
        StringFormField(
          maxLines: 3,
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
      ],
    );
  }
}
