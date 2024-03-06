import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';
import 'package:xpenses/entities/tag_entity.dart';
import 'package:xpenses/object_box.dart';
import 'package:xpenses/widgets/form_fields/color_form_field.dart';
import 'package:xpenses/widgets/form_fields/string_form_field.dart';
import 'package:xpenses/widgets/tag_chip.dart';

class NewTagPage extends StatefulWidget {
  const NewTagPage({super.key});

  @override
  State<NewTagPage> createState() => _NewTagPageState();
}

class _NewTagPageState extends State<NewTagPage> {
  late String _text;
  late Color _color;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _text = '';
    _color = Colors.grey;
    _formKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Tag'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TagChip(
                text: _text,
                color: _color,
              ),
            ),
            StringFormField(
              maxLines: 1,
              onChanged: (value) {
                setState(() {
                  _text = value;
                });
              },
            ),
            ColorFormField(
              onChanged: (value) => setState(() {
                _color = value;
              }),
            ),
            ElevatedButton(
              onPressed: _save,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final tag = Tag(name: _text, color: _color);
      final box = context.read<Box<Tag>>();
      box.put(tag);
      _formKey.currentState!.reset();
    } else {
      print('Não é válido');
    }
  }
}
