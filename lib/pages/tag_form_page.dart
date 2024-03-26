import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:xpenses/entities/tag_entity.dart';
import 'package:xpenses/enums/form_field_enum.dart';
import 'package:xpenses/widgets/form_fields/color_form_field.dart';
import 'package:xpenses/widgets/form_fields/icon_form_field.dart';
import 'package:xpenses/widgets/form_fields/string_form_field.dart';
import 'package:xpenses/widgets/tag_chip.dart';
import 'package:xpenses/pages/entity_form.dart';

class NewTagPage extends StatefulWidget {
  const NewTagPage({super.key});

  @override
  State<NewTagPage> createState() => _NewTagPageState();
}

class _NewTagPageState extends State<NewTagPage> {
  late String _text;
  late Color _color;
  late String? _iconName;

  @override
  void initState() {
    super.initState();
    _text = '';
    _iconName = null;
    _color = Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return EntityForm<Tag>(
      appbar: AppBar(title: const Text('Nova Tag')),
      header: Padding(
        padding: const EdgeInsets.all(12),
        child: TagChip(
          text: _text,
          color: _color,
          icon: iconMap[_iconName],
        ),
      ),
      formFields: [
        StringFormField<Tag>(
          maxLines: 1,
          initialValue: '',
          field: FormFieldEnum.tagName,
          onChanged: (value) {
            setState(() {
              _text = value;
            });
          },
        ),
        ColorFormField<Tag>(
          field: FormFieldEnum.tagColor,
          initialValue: Colors.grey,
          onChanged: (value) => setState(() {
            _color = value;
          }),
        ),
        IconFormField<Tag>(
          field: FormFieldEnum.tagIcon,
          initialValue: null,
          onChanged: (value) => setState(() {
            _iconName = value;
          }),
        ),
      ],
    );
  }
}
