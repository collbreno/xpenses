import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/bloc/expense_cubit.dart';
import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/widgets/async_data_builder.dart';
import 'package:xpenses/widgets/expense_details.dart';

class ExpenseDetailsPage extends StatelessWidget {
  const ExpenseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gasto'),
      ),
      body: BlocBuilder<ExpenseCubit, AsyncData<Expense>>(
        builder: (context, state) {
          return AsyncDataBuilder(
            state: state,
            builder: (context, data) {
              return ExpenseDetails(data);
            },
          );
        },
      ),
    );
  }
}
