import 'package:xpenses/bloc/entity_form_cubit.dart';
import 'package:xpenses/entities/expense_entity.dart';
import 'package:xpenses/enums/form_field_enum.dart';

class ExpenseFormCubit extends EntityFormCubit<Expense> {
  ExpenseFormCubit(super.box);

  @override
  Expense mapFieldsToEntity(Map<FormFieldEnum, dynamic> fields) {
    return Expense(
      description: fields[FormFieldEnum.expenseDescription],
      date: fields[FormFieldEnum.expenseDate],
      value: fields[FormFieldEnum.expenseValue],
    )..tags.addAll(
        fields[FormFieldEnum.expenseTags],
      );
  }
}
