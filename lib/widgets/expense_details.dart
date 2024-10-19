import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/models/installment_model.dart';
import 'package:xpenses/utils/date_utils.dart';
import 'package:xpenses/widgets/tag_chip.dart';

class ExpenseDetails extends StatelessWidget {
  final Expense expense;
  const ExpenseDetails(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(title: Text(expense.title)),
        ListTile(
          title: Text(expense.totalValue!.toString()),
          subtitle: Text('Minha parte: ${expense.myPart!}'),
          trailing: Text(expense.firstDate!.formatDMY()),
        ),
        if (expense.description.isNotEmpty)
          ListTile(title: Text(expense.description)),
        const Divider(indent: 16, endIndent: 16),
        for (final installment in expense.installments!)
          _buildInstallment(installment),
        const Divider(indent: 16, endIndent: 16),
        _buildTags(),
      ],
    );
  }

  Widget _buildTags() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: MasonryGridView.builder(
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        shrinkWrap: true,
        itemCount: expense.tags!.length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.centerLeft,
          child: TagChip.fromTag(expense.tags![index]),
        ),
      ),
    );
  }

  Widget _buildInstallment(Installment installment) {
    return ListTile(
      title: Text(installment.value.toString()),
      titleAlignment: ListTileTitleAlignment.top,
      trailing: Text(installment.date.formatDMY()),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: installment.personParts
              .map(
                (e) => Row(
                  children: [
                    Text(
                      e.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      e.value.toString(),
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
