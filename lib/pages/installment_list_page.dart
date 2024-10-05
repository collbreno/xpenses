import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/bloc/entity_list_cubit.dart';
import 'package:xpenses/entities/installment_entity.dart';
import 'package:xpenses/utils/async_data.dart';

class InstallmentListPage extends StatelessWidget {
  const InstallmentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Installments')),
      body: BlocBuilder<EntityListCubit<Installment>,
          AsyncData<List<Installment>>>(
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
              'The $AsyncData state of ${EntityListCubit<Installment>} is invalid.',
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

  void _loadList(BuildContext context) {
    context.read<EntityListCubit<Installment>>().load();
  }

  Widget _buildList(List<Installment> installments) {
    return Builder(builder: (context) {
      return RefreshIndicator(
        onRefresh: () async => _loadList(context),
        child: ListView.builder(
          itemCount: installments.length,
          itemBuilder: (context, index) {
            final installment = installments[index];
            return ListTile(
              trailing: Text('${installment.expense.targetId}'),
              leading: Text(
                  '${installment.date.day.toString().padLeft(2, '0')}/${installment.date.month.toString().padLeft(2)}'),
              title: Text(installment.value.toString()),
              subtitle:
                  Text('Total: ${installment.expense.target?.totalValue}'),
            );
          },
        ),
      );
    });
  }
}
