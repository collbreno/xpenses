// ignore_for_file: null_check_on_nullable_type_parameter

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/bloc/entity_list_cubit.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/widgets/picker_dialog.dart';

class EntityFormField<T> extends FormField<T> {
  EntityFormField({
    required Widget Function(T) itemBuilder,
    ValueChanged? onChanged,
    Alignment checkPosition = Alignment.center,
    super.onSaved,
    super.key,
  }) : super(
          builder: (formState) {
            return BlocBuilder<EntityListCubit<T>, AsyncData<List<T>>>(
              builder: (context, cubitState) {
                return ListTile(
                  onTap: !cubitState.hasData
                      ? null
                      : () async {
                          final result = await showPickerDialog(
                            checkPosition: checkPosition,
                            context: context,
                            columns: 1,
                            itemBuilder: itemBuilder,
                            initialValue: formState.value,
                            items: cubitState.data!,
                          );

                          if (result != null) {
                            formState.didChange(result);
                            onChanged?.call(result);
                          }
                        },
                  title: InputDecorator(
                    isEmpty: formState.value == null,
                    decoration: InputDecoration(
                      enabled: cubitState.hasData,
                      icon: const Icon(Icons.label),
                      border: const OutlineInputBorder(),
                      hintText: 'Insira as tags',
                      labelText: 'Tags',
                      errorText: formState.errorText,
                      suffixIcon: cubitState.isLoading
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            )
                          : cubitState.hasError
                              ? Icon(
                                  Icons.cancel,
                                  color: Theme.of(context).colorScheme.error,
                                )
                              : const Icon(Icons.arrow_drop_down),
                    ),
                    child: formState.value == null
                        ? null
                        : itemBuilder(formState.value!),
                  ),
                );
              },
            );
          },
        );
}
