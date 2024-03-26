import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:xpenses/bloc/entity_form_cubit.dart';
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
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _text = '';
    _iconName = null;
    _color = Colors.grey;
    _formKey = GlobalKey();
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
        StringFormField(
          maxLines: 1,
          initialValue: '',
          onChanged: (value) {
            setState(() {
              _text = value;
            });
          },
          onSaved: (value) => context
              .read<EntityFormCubit<Tag>>()
              .saveField(FormFieldEnum.tagName, value),
        ),
        ColorFormField(
          initialValue: Colors.grey,
          onChanged: (value) => setState(() {
            _color = value;
          }),
          onSaved: (value) => context
              .read<EntityFormCubit<Tag>>()
              .saveField(FormFieldEnum.tagColor, value),
        ),
        IconFormField(
          initialValue: null,
          onChanged: (value) => setState(() {
            _iconName = value;
          }),
          onSaved: (value) => context
              .read<EntityFormCubit<Tag>>()
              .saveField(FormFieldEnum.tagIcon, value),
        ),
      ],
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<EntityFormCubit<Tag>>().save();
    }
  }
}
