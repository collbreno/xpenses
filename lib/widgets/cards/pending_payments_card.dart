import 'package:flutter/material.dart';
import 'package:xpenses/bloc/pending_payments_cubit.dart';
import 'package:xpenses/widgets/async_data_builder.dart';
import 'package:xpenses/widgets/text_placeholder.dart';

class PendingPaymentsCard extends StatelessWidget {
  final PendingPaymentsState state;
  const PendingPaymentsCard(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pagamentos Pendentes',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: AsyncDataBuilder(
                  state: state.list,
                  loadingBuilder: _buildLoading,
                  builder: (context, data) {
                    if (data.isEmpty) {
                      return const Center(
                        child: Text('Nenhum pagamento pendente'),
                      );
                    }
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final payment = data[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(payment.name),
                          trailing: Text(payment.value.toString()),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(context) {
    return const Column(
      children: [
        SizedBox(height: 8),
        TextPlaceholder(Size(double.infinity, 32)),
        SizedBox(height: 8),
        TextPlaceholder(Size(double.infinity, 32)),
        SizedBox(height: 8),
        TextPlaceholder(Size(double.infinity, 32)),
      ],
    );
  }
}
