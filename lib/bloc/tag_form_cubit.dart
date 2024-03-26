import 'package:xpenses/bloc/entity_form_cubit.dart';
import 'package:xpenses/entities/tag_entity.dart';
import 'package:xpenses/enums/form_field_enum.dart';

class TagFormCubit extends EntityFormCubit<Tag> {
  TagFormCubit(super.box);

  @override
  Tag mapFieldsToEntity(Map<FormFieldEnum, dynamic> fields) {
    return Tag(
      name: state.fields[FormFieldEnum.tagName],
      iconName: state.fields[FormFieldEnum.tagIcon],
      color: state.fields[FormFieldEnum.tagColor],
    );
  }
}
