import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xpenses/bloc/month_total_cubit.dart';
import 'package:xpenses/go_router_builder.dart';
import 'package:xpenses/widgets/async_data_builder.dart';

class MonthTotalCard extends StatelessWidget {
  final MonthTotalState state;
  const MonthTotalCard(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(24),
      child: InkWell(
        onTap: () {
          const InstallmentsRoute().push(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Esse mês:',
                style: TextStyle(fontSize: 16),
              ),
              AsyncDataBuilder(
                state: state.thisMonth,
                loadingBuilder: (context) => _buildShimmer(Size(120, 36)),
                builder: (context, data) {
                  return SizedBox(
                    height: 36,
                    child: FittedBox(
                      child: Text(
                        data.toString(),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Mês passado:'),
                  const SizedBox(width: 6),
                  AsyncDataBuilder(
                    state: state.prevMonth,
                    loadingBuilder: (context) => _buildShimmer(Size(80, 24)),
                    builder: (context, data) {
                      return SizedBox(
                        height: 24,
                        child: FittedBox(child: Text(data.toString())),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
      ),
    );
  }
}
