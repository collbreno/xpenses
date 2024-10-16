import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:xpenses/database/i_database.dart';
import 'package:xpenses/models/tag_model.dart';
import 'package:xpenses/utils/string_validators.dart';
import 'package:xpenses/widgets/form_fields/color_form_field.dart';
import 'package:xpenses/widgets/form_fields/icon_form_field.dart';
import 'package:xpenses/widgets/form_fields/string_form_field.dart';
import 'package:xpenses/widgets/tag_chip.dart';
import 'package:xpenses/pages/entity_form.dart';

class TagFormPage extends StatefulWidget {
  final Tag? tag;
  final VoidCallback onSaved;
  const TagFormPage({
    super.key,
    this.tag,
    required this.onSaved,
  });

  @override
  State<TagFormPage> createState() => _TagFormPageState();
}

class _TagFormPageState extends State<TagFormPage> {
  late Tag _tag;
  late String _previewName;
  late Color _previewColor;
  late String? _previewIcon;

  bool get _isUpdate => widget.tag != null;

  @override
  void initState() {
    super.initState();
    _tag = widget.tag ??
        const Tag(
          id: 0,
          name: '',
          iconName: '',
          color: Colors.grey,
        );
    _previewName = _tag.name;
    _previewColor = _tag.color;
    _previewIcon = _tag.iconName;
  }

  @override
  Widget build(BuildContext context) {
    return EntityForm(
      onSave: () async {
        final db = context.read<IAppDatabase>();
        if (_isUpdate) {
          if (await db.updateTag(_tag)) {
            widget.onSaved();
          }
        } else {
          await db.addTag(_tag);
          widget.onSaved();
        }
      },
      // onDelete: widget.tag == null
      //     ? null
      //     : () async {
      //         await context.read<Box<Tag>>().removeAsync(widget.tag!.id);
      //         widget.onSaved();
      //       },
      appbarTitle: Text(_isUpdate ? 'Editar Tag' : 'Nova Tag'),
      header: Padding(
        padding: const EdgeInsets.all(12),
        child: TagChip(
          color: _previewColor,
          text: _previewName,
          icon: iconMap[_previewIcon],
          alignment: Alignment.center,
        ),
      ),
      formFields: [
        StringFormField(
          onChanged: (value) => setState(() {
            _previewName = value!;
          }),
          onSaved: _setText,
          maxLines: 1,
          initialValue: _tag.name,
          label: 'Título',
          validator: StringValidators.notEmpty(),
        ),
        ColorFormField(
          onChanged: (value) => setState(() {
            _previewColor = value!;
          }),
          onSaved: _setColor,
          initialValue: _tag.color,
        ),
        IconFormField(
          onChanged: (value) => setState(() {
            _previewIcon = value;
          }),
          onSaved: _setIconName,
          initialValue: _tag.iconName,
        ),
      ],
    );
  }

  void _setText(String? text) {
    setState(() {
      _tag = _tag.copy(name: text!);
    });
  }

  void _setColor(Color? color) {
    setState(() {
      _tag = _tag.copy(color: color!);
    });
  }

  void _setIconName(String? iconName) {
    setState(() {
      _tag = _tag.copy(iconName: iconName ?? '');
    });
  }
}
