import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xpenses/bloc/expense_cubit.dart';
import 'package:xpenses/database/i_database.dart';
import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/utils/build_context_utils.dart';
import 'package:xpenses/widgets/async_data_builder.dart';
import 'package:xpenses/widgets/dialogs/error_dialog.dart';
import 'package:xpenses/widgets/dialogs/loading_dialog.dart';
import 'package:xpenses/widgets/expense_details.dart';

class ExpenseDetailsPage extends StatefulWidget {
  const ExpenseDetailsPage({super.key});

  @override
  State<ExpenseDetailsPage> createState() => _ExpenseDetailsPageState();
}

class _ExpenseDetailsPageState extends State<ExpenseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, AsyncData<Expense>>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gasto'),
            actions: [
              IconButton(
                onPressed: _delete,
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          body: AsyncDataBuilder(
            state: state,
            builder: (context, data) {
              return ExpenseDetails(data);
            },
          ),
        );
      },
    );
  }

  Future<void> _delete() async {
    showLoadingDialog(context);
    try {
      final id = context.read<ExpenseCubit>().id;
      await context.read<IAppDatabase>().deleteExpense(id);
      if (mounted) {
        context.dismissDialog();
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        context.dismissDialog();
        showErrorDialog(context, error: e);
      }
      rethrow;
    }
  }
}
