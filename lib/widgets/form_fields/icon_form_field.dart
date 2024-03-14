import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:xpenses/widgets/picker_dialog.dart';

class IconFormField extends FormField<String> {
  IconFormField({
    super.key,
    super.initialValue,
    super.onSaved,
    ValueChanged<String?>? onChanged,
  }) : super(
          builder: (state) {
            return Builder(
              builder: (context) {
                return ListTile(
                  onTap: () async {
                    final result = await showPickerDialog<String>(
                      onSearch: (item, text) =>
                          item.toUpperCase().contains(text.toUpperCase()),
                      context: context,
                      itemBuilder: (iconName) => FittedBox(
                        child: Icon(
                          iconMap[iconName],
                        ),
                      ),
                      items: MdiIcons.getNames(),
                      initialValue: state.value,
                      columns: 5,
                    );
                    state.didChange(result);
                    onChanged?.call(result);
                  },
                  title: InputDecorator(
                    isEmpty: state.value == null,
                    decoration: InputDecoration(
                      icon: Icon(MdiIcons.stickerEmoji),
                      border: const OutlineInputBorder(),
                      hintText: 'Insira o ícone',
                      labelText: 'Ícone',
                      errorText: state.errorText,
                      prefixIcon: state.value == null
                          ? null
                          : Icon(iconMap[state.value]),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    child: state.value == null ? null : Text(state.value!),
                  ),
                );
              },
            );
          },
        );
}
