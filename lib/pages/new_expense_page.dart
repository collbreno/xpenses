import 'package:flutter/material.dart';
import 'package:xpenses/widgets/calculator.dart';
import 'package:xpenses/widgets/form_fields/date_form_field.dart';
import 'package:xpenses/widgets/form_fields/value_form_field.dart';

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({super.key});

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  late TextEditingController _valueController;
  late TextEditingController _dateController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController();
    _dateController = TextEditingController();
    _formKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Novo gasto'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    ValueFormField(),
                    DateFormField(),
                    _buildDescription(),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.validate();
                  },
                  child: Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValue() {
    return ListTile(
      title: TextFormField(
        onTap: () async {
          final result = await showCalculator(context);
          if (result != null) {
            setState(() {
              _valueController.text = result.toString();
            });
          }
        },
        readOnly: true,
        controller: _valueController,
        decoration: const InputDecoration(
          icon: Icon(Icons.attach_money),
          border: OutlineInputBorder(),
          hintText: 'Insira o valor',
          labelText: 'Valor',
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Não pode ser vazio';
          final parsed = double.tryParse(value);
          if (parsed == null) return 'Número inválido';
          if (parsed.isNegative) return 'Não pode ser negativo';
          return null;
        },
      ),
    );
  }

  Widget _buildDate() {
    return ListTile(
      title: TextFormField(
        onTap: () async {
          final result = await showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );

          if (result != null) {
            setState(() {
              _dateController.text = result.toIso8601String();
            });
          }
        },
        readOnly: true,
        controller: _dateController,
        decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
          hintText: 'Insira a data',
          labelText: 'Data',
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return ListTile(
      title: TextFormField(
        maxLines: 5,
        minLines: 1,
        decoration: const InputDecoration(
          icon: Icon(Icons.edit),
          border: OutlineInputBorder(),
          hintText: 'Insira a descrição',
          labelText: 'Descrição',
        ),
        validator: (value) {
          if (value == null) return 'Não pode ser vazio';
          if (value.contains('x')) return 'Inválido';
          return null;
        },
      ),
    );
  }
}
