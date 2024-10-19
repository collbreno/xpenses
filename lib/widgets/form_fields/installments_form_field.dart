import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/utils/focus_utils.dart';

class InstallmentsFormField extends FormField<int> {
  InstallmentsFormField({
    super.key,
    required Money totalValue,
    super.initialValue,
    super.onSaved,
  }) : super(
          validator: (value) {
            if (value == null) return 'Número inválido';
            if (value < 0) return 'Deve ser maior que zero';
            return null;
          },
          builder: (state) {
            final isAvista = state.value == 1;
            final installmentValue = state.value != null && state.value! > 0
                ? totalValue / state.value!
                : null;

            return Builder(builder: (context) {
              return ListTile(
                subtitle: !isAvista && state.hasError
                    ? _buildError(state, context)
                    : null,
                title: Column(
                  children: [
                    _buildToggle(isAvista, state),
                    if (!isAvista) _buildInput(state, installmentValue),
                  ],
                ),
              );
            });
          },
        );

  static Widget _buildInput(
    FormFieldState<int> state,
    Money? installmentValue,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nº de parcelas',
                  error: state.hasError ? Container() : null,
                ),
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  state.didChange(parsed == 1 ? null : parsed);
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                'Valor da parcela: ${installmentValue?.toString() ?? '-'}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  static LayoutBuilder _buildToggle(bool isAvista, FormFieldState<int> state) {
    return LayoutBuilder(builder: (context, constraints) {
      return ToggleButtons(
        borderRadius: BorderRadius.circular(8),
        constraints: BoxConstraints.expand(
          width: constraints.maxWidth / 2 - 3,
        ),
        borderWidth: 1,
        isSelected: [isAvista, !isAvista],
        onPressed: (index) {
          FocusUtils.unfocus();
          if (index == 0) {
            state.didChange(1);
          } else {
            if (state.value == 1) {
              state.didChange(null);
            }
          }
        },
        children: const [
          Text('À vista'),
          Text('Parcelado'),
        ],
      );
    });
  }

  static Padding _buildError(FormFieldState<int> state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        state.errorText!,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}
