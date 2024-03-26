part of 'entity_form_cubit.dart';

class EntityFormState extends Equatable {
  final Map<FormFieldEnum, dynamic> fields;
  final bool loading;

  const EntityFormState._({
    required this.fields,
    required this.loading,
  });

  EntityFormState.initial()
      : fields = {},
        loading = false;

  EntityFormState withLoading(bool loading) {
    return EntityFormState._(
      fields: fields,
      loading: loading,
    );
  }

  EntityFormState withField(FormFieldEnum field, dynamic value) {
    final map = Map<FormFieldEnum, dynamic>.from(fields);
    map[field] = value;

    return EntityFormState._(
      fields: map,
      loading: loading,
    );
  }

  @override
  List<Object?> get props => [loading, fields];
}
