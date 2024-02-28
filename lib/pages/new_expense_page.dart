import 'package:flutter/material.dart';
import 'package:xpenses/widgets/calculator.dart';

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({super.key});

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Novo gasto'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildValue(),
                  _buildDescription(),
                ],
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(onPressed: () {}, child: Text('Salvar')),
            )
          ],
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
              _valueController.text = result;
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
      ),
    );
  }
}
