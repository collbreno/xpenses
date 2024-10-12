import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:xpenses/utils/focus_utils.dart';
import 'package:xpenses/utils/string_utils.dart';
import 'package:xpenses/widgets/picker_dialog.dart';

class IconFormField extends FormField<String> {
  IconFormField({
    super.key,
    super.initialValue,
    ValueChanged<String?>? onChanged,
    required super.onSaved,
  }) : super(
          builder: (state) {
            return Builder(
              builder: (context) {
                return ListTile(
                  trailing: state.value.isNullOrEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            state.didChange('');
                            onChanged?.call('');
                          },
                        ),
                  onTap: () async {
                    FocusUtils.unfocus();
                    final result = await showPickerDialog<String>(
                      props: PickerDialogProps(
                        onSearch: (item, text) {
                          return item.toUpperCase().contains(
                                text.toUpperCase(),
                              );
                        },
                        itemBuilder: (iconName) => FittedBox(
                          child: Icon(
                            iconMap[iconName],
                          ),
                        ),
                        items: MdiIcons.getNames(),
                        columns: 5,
                      ),
                      context: context,
                      initialValue: state.value,
                    );
                    state.didChange(result);
                    onChanged?.call(result);
                  },
                  title: InputDecorator(
                    isEmpty: state.value.isNullOrEmpty,
                    decoration: InputDecoration(
                      icon: Icon(MdiIcons.stickerEmoji),
                      border: const OutlineInputBorder(),
                      hintText: 'Insira o ícone',
                      labelText: 'Ícone',
                      errorText: state.errorText,
                      prefixIcon: state.value.isNullOrEmpty
                          ? null
                          : Icon(iconMap[state.value]),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    child: state.value.isNullOrEmpty
                        ? null
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(state.value!),
                          ),
                  ),
                );
              },
            );
          },
        );
}
