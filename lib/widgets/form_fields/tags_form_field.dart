// ignore_for_file: null_check_on_nullable_type_parameter

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/bloc/entity_list_cubit.dart';
import 'package:xpenses/entities/tag_entity.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/widgets/picker_dialog.dart';
import 'package:xpenses/widgets/tag_chip.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TagsFormField extends FormField<Iterable<Tag>> {
  TagsFormField({
    ValueChanged<Iterable<Tag>>? onChanged,
    super.onSaved,
    super.key,
    super.initialValue,
  }) : super(
          builder: (formState) {
            return BlocBuilder<EntityListCubit<Tag>, AsyncData<List<Tag>>>(
              builder: (context, cubitState) {
                return ListTile(
                  onTap: !cubitState.hasData
                      ? null
                      : () async {
                          final result = await showMultiPickerDialog(
                            props: PickerDialogProps<Tag>(
                              checkPosition: Alignment.centerRight,
                              itemBuilder: (tag) => ListTile(
                                dense: true,
                                title: TagChip.fromTag(tag),
                              ),
                              columns: 1,
                              items: cubitState.data!,
                              onSearch: (item, text) => item.name
                                  .toUpperCase()
                                  .contains(text.toUpperCase()),
                            ),
                            context: context,
                            initialValue: formState.value,
                          );

                          if (result != null) {
                            formState.didChange(result);
                            onChanged?.call(result);
                          }
                        },
                  title: InputDecorator(
                    isEmpty: formState.value!.isEmpty,
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
                    child: formState.value!.isEmpty
                        ? null
                        : MasonryGridView.builder(
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            shrinkWrap: true,
                            itemCount: formState.value!.length,
                            itemBuilder: (context, index) => Align(
                              alignment: Alignment.centerLeft,
                              child: TagChip.fromTag(
                                formState.value!.toList()[index],
                              ),
                            ),
                          ),
                  ),
                );
              },
            );
          },
        );
}
