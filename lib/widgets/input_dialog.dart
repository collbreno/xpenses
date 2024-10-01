import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final String? labelText;
  final String? hintText;
  const InputDialog({
    super.key,
    required this.title,
    this.initialValue,
    this.validator,
    this.labelText,
    this.hintText,
  });

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: true,
          onFieldSubmitted: (_) => _confirm(),
          controller: _controller,
          validator: widget.validator,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: widget.labelText,
            hintText: widget.hintText,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _confirm,
          child: const Text('Ok'),
        ),
      ],
    );
  }

  void _confirm() {
    if (_formKey.currentState!.validate()) {
      context.pop(_controller.text);
    }
  }
}

Future<String?> showInputDialog({
  required BuildContext context,
  required String title,
  String? initialValue,
  FormFieldValidator<String>? validator,
  String? labelText,
  String? hintText,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => InputDialog(
      title: title,
      initialValue: initialValue,
      validator: validator,
      labelText: labelText,
      hintText: hintText,
    ),
  );
}
