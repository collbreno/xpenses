import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/bloc/installments_cubit.dart';
import 'package:xpenses/models/installment_model.dart';
import 'package:xpenses/utils/async_data.dart';
import 'package:xpenses/utils/month.dart';
import 'package:xpenses/widgets/app_error_widget.dart';
import 'package:xpenses/widgets/async_data_builder.dart';
import 'package:xpenses/widgets/installment_list.dart';

class InstallmentsPage extends StatelessWidget {
  const InstallmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstallmentsCubit, InstallmentsState>(
      builder: (context, state) {
        return AsyncDataBuilder(
          state: state.range,
          builder: (context, _) {
            return _buildPage(state);
          },
          loadingBuilder: (context) => _buildScaffold(
            const Center(child: CircularProgressIndicator()),
          ),
          errorBuilder: (context, error) => _buildScaffold(
            AppErrorWidget(error),
          ),
        );
      },
    );
  }

  Widget _buildScaffold(Widget body) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Gastos')),
      body: body,
    );
  }

  Widget _buildPage(InstallmentsState state) {
    final months = state.months!;
    return Builder(builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      return DefaultTabController(
        length: months.length,
        initialIndex: months.indexOf(DateTime.now().monthYear),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Meus Gastos'),
            bottom: TabBar(
              splashBorderRadius: BorderRadius.circular(100),
              onTap: (index) async {
                final month = months[index];
                if (state.getByMonth(month).hasNothing) {
                  await context.read<InstallmentsCubit>().loadMonth(month);
                }
              },
              isScrollable: true,
              padding: const EdgeInsets.only(bottom: 8),
              labelColor: scheme.onPrimary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: scheme.primary,
              ),
              tabs: months
                  .map((e) => Tab(
                        height: 36,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(e.format()),
                        ),
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children: months
                .map((e) => _buildMonthPage(e, state.getByMonth(e)))
                .toList(),
          ),
        ),
      );
    });
  }

  Widget _buildMonthPage(
    Month month,
    AsyncData<List<Installment>> installments,
  ) {
    return AsyncDataBuilder(
      state: installments,
      nothingBuilder: (context) {
        context.read<InstallmentsCubit>().loadMonth(month);
        return const Center(child: CircularProgressIndicator());
      },
      builder: (context, data) => InstallmentList(data),
    );
  }
}
