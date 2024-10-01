import 'package:flutter/material.dart';
import 'package:xpenses/utils/color_utils.dart';
import 'package:xpenses/utils/focus_utils.dart';
import 'package:xpenses/widgets/picker_dialog.dart';

class ColorFormField extends FormField<Color> {
  ColorFormField({
    super.key,
    required super.initialValue,
    required super.onSaved,
    ValueChanged<Color?>? onChanged,
  }) : super(
          builder: (state) {
            return Builder(
              builder: (context) {
                return ListTile(
                  onTap: () async {
                    FocusUtils.unfocus();
                    final result = await showPickerDialog(
                      props: PickerDialogProps<Color>(
                        columns: 5,
                        items: ColorUtils.getColorList(),
                        itemBuilder: (color) {
                          return Icon(
                            Icons.circle,
                            color: color,
                            size: 48,
                          );
                        },
                      ),
                      context: context,
                      initialValue: state.value,
                    );
                    if (result != null) {
                      state.didChange(result);
                      onChanged?.call(result);
                    }
                  },
                  title: InputDecorator(
                    isEmpty: state.value == null,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.palette),
                      border: const OutlineInputBorder(),
                      hintText: 'Insira a cor',
                      labelText: 'Cor',
                      errorText: state.errorText,
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    child: state.value == null
                        ? null
                        : Container(
                            width: double.maxFinite,
                            height: 20,
                            color: state.value,
                          ),
                  ),
                );
              },
            );
          },
        );
}
