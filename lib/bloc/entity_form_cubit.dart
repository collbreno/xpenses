import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/enums/form_field_enum.dart';

part 'entity_form_state.dart';

abstract class EntityFormCubit<T> extends Cubit<EntityFormState> {
  Future<int> Function(T entity) method;

  EntityFormCubit(this.method) : super(EntityFormState.initial());

  Future<void> save() async {
    emit(state.withLoading(true));
    await method(mapFieldsToEntity(state.fields));
    emit(state.withLoading(false));
  }

  void saveField(FormFieldEnum field, dynamic value) {
    emit(state.withField(field, value));
  }

  T mapFieldsToEntity(Map<FormFieldEnum, dynamic> fields);
}
