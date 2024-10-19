import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/models/expense_model.dart';
import 'package:xpenses/models/installment_model.dart';
import 'package:xpenses/models/person_part_model.dart';
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
          trailing: Text(expense.firstDate!.formatDMY()),
        ),
        if (expense.description.isNotEmpty)
          ListTile(title: Text(expense.description)),
        if (expense.totalValue != expense.myPart) ...[
          const Divider(indent: 16, endIndent: 16),
          _buildPersonParts(),
        ],
        if (expense.installments!.length != 1) ...[
          const Divider(indent: 16, endIndent: 16),
          for (final installment in expense.installments!)
            _buildInstallment(installment),
        ],
        if (expense.tags!.isNotEmpty) ...[
          const Divider(indent: 16, endIndent: 16),
          _buildTags(),
        ],
      ],
    );
  }

  Widget _buildPersonParts() {
    final me = PersonPart(id: 0, value: expense.myPart!, name: 'Eu');
    final personParts = expense.installments!
        .fold(<PersonPart>[], (acc, e) => acc + e.personParts)
        .groupFoldBy<String, Money>(
            (e) => e.name, (acc, e) => acc == null ? e.value : acc + e.value)
        .entries
        .map((e) => PersonPart(id: 0, value: e.value, name: e.key));

    final list = [me, ...personParts];
    return Column(
      children: list
          .map((e) => ListTile(
                dense: true,
                minTileHeight: 20,
                title: Text(e.name),
                trailing: Text(e.value.toString()),
              ))
          .toList(),
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
      dense: true,
      minTileHeight: 20,
      title: Text(installment.value.toString()),
      trailing: Text(installment.date.formatDMY()),
    );
  }
}
