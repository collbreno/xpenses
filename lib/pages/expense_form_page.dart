import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/database/i_database.dart';
import 'package:xpenses/expense_generator.dart';
import 'package:xpenses/models/expense_model.dart';
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
  late final ExpenseGenerator _generator;

  @override
  void initState() {
    super.initState();
    _generator = widget.expense != null
        ? ExpenseGenerator.fromExpense(widget.expense!)
        : ExpenseGenerator();
  }

  @override
  Widget build(BuildContext context) {
    return EntityForm(
      appbarTitle: const Text('Novo Gasto'),
      onSave: () async {
        await context.read<IAppDatabase>().addExpense(_generator.generate());
        widget.onSaved();
      },
      // onDelete: widget.expense == null
      //     ? null
      //     : () async {
      //         await context
      //             .read<Box<Expense>>()
      //             .removeAsync(widget.expense!.id);
      //         widget.onSaved();
      //       },
      formFields: [
        ValueFormField(
          initialValue: _generator.value,
          onSaved: (value) => setState(() {
            _generator.value = value!;
          }),
          onChanged: (value) => setState(() {
            _generator.value = value!;
          }),
        ),
        DateFormField(
          initialValue: _generator.date,
          onSaved: (value) => setState(() {
            _generator.date = value!;
          }),
        ),
        StringFormField(
          maxLines: 3,
          icon: const Icon(Icons.edit),
          hint: 'Insira o título',
          label: 'Título',
          initialValue: _generator.description,
          onSaved: (value) => setState(() {
            _generator.title = value!;
          }),
        ),
        TagsFormField(
          initialValue: _generator.tags.toSet(),
          onSaved: (value) => setState(() {
            _generator.tags = value!.toList();
          }),
        ),
        InstallmentsFormField(
          totalValue: _generator.value,
          initialValue: 1,
          onSaved: (value) => setState(() {
            _generator.nInstallments = value!;
          }),
        ),
        PeopleFormField(
          totalValue: _generator.value,
          initialValue: _generator.personParts,
          onSaved: (value) => setState(() {
            _generator.personParts = value!.toList();
          }),
        ),
      ],
    );
  }
}
