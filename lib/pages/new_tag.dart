import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _text = '';
    _color = Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Tag'),
      ),
      body: Column(
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
        ],
      ),
    );
  }
}
