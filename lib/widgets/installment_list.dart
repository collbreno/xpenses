import 'package:flutter/material.dart';
import 'package:xpenses/go_router_builder.dart';
import 'package:xpenses/models/installment_model.dart';

class InstallmentList extends StatelessWidget {
  final List<Installment> installments;
  const InstallmentList(this.installments, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: installments.length,
      itemBuilder: (context, index) {
        final installment = installments[index];
        return ListTile(
          onTap: () {
            ExpenseDetailsRoute(installment.expense!.id).push(context);
          },
          dense: true,
          title: Text(installment.expense!.title),
          leading: Text('${installment.date.day.toString().padLeft(2, '0')}'
              '/${installment.date.month.toString().padLeft(2)}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(installment.value.toString()),
              if (installment.totalCount! > 1)
                Text(
                  '${installment.index + 1}'
                  ' de ${installment.totalCount!}',
                  style: const TextStyle(fontWeight: FontWeight.w300),
                )
            ],
          ),
        );
      },
    );
  }
}
