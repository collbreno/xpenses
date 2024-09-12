import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/bloc/entity_list_cubit.dart';
import 'package:xpenses/entities/expense_entity.dart';
import 'package:xpenses/go_router_builder.dart';
import 'package:xpenses/route_params/expense_form_route_params.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/widgets/tag_chip.dart';

class ExpenseListPage extends StatelessWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gastos')),
      body: BlocBuilder<EntityListCubit<Expense>, AsyncData<List<Expense>>>(
        builder: (context, state) {
          if (state.isLoading) {
            return _buildLoading();
          } else if (state.hasError) {
            return _buildError(state.error!);
          } else if (state.hasData) {
            if (state.data!.isEmpty) {
              return _buildEmptyList();
            } else {
              return _buildList(state.data!);
            }
          } else {
            throw ArgumentError(
              'The $AsyncData state of ${EntityListCubit<Expense>} is invalid.',
            );
          }
        },
      ),
    );
  }

  Widget _buildEmptyList() {
    return const Center(child: Text('Nenhum item'));
  }

  Widget _buildError(Object error) {
    return const Center(child: Text('Algo deu errado'));
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<Expense> expenses) {
    return Builder(builder: (context) {
      return RefreshIndicator(
        onRefresh: () => context.read<EntityListCubit<Expense>>().load(),
        child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return ListTile(
              onTap: () {
                ExpenseFormRoute(ExpenseFormRouteParams(
                  expense: expense,
                  onSaved: () =>
                      context.read<EntityListCubit<Expense>>().load(),
                )).push(context);
              },
              title: Text(expense.description),
              trailing: Text(expense.value.toString()),
              subtitle: expense.tags.isEmpty
                  ? null
                  : Row(
                      children: expense.tags
                          .map((tag) => TagChip.fromTag(tag))
                          .toList(),
                    ),
            );
          },
        ),
      );
    });
  }
}
