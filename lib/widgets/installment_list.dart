import 'package:flutter/material.dart';
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
          dense: true,
          title: Text(_getInstallmentTitle(installment)),
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

  String _getInstallmentTitle(Installment installment) {
    final title = installment.expense!.title;
    return title;
  }
}
