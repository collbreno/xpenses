import 'package:flutter/material.dart';
import 'package:xpenses/widgets/selectable_item.dart';

typedef ItemBuilder<T> = Widget Function(T);

class PickerDialog<T> extends StatefulWidget {
  final List<T> items;
  final ItemBuilder<T> itemBuilder;
  final int columns;
  final T? initialValue;
  final Alignment checkPosition;
  const PickerDialog({
    super.key,
    required this.itemBuilder,
    required this.items,
    this.initialValue,
    this.columns = 1,
    this.checkPosition = Alignment.center,
  });

  @override
  State<PickerDialog<T>> createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<PickerDialog<T>> {
  T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Selecione'),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: widget.columns == 1
            ? ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: _itemBuilder,
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.columns,
                ),
                itemCount: widget.items.length,
                itemBuilder: _itemBuilder,
              ),
      ),
      actions: _buildActions(),
    );
  }

  Widget? _itemBuilder(context, index) {
    final item = widget.items[index];
    return SelectableItem(
      alignment: widget.checkPosition,
      selected: item == _selected,
      onTap: () {
        setState(() {
          _selected = item == _selected ? null : item;
        });
      },
      child: widget.itemBuilder(
        item,
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cancelar'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context, _selected);
        },
        child: Text('Ok'),
      ),
    ];
  }
}

Future<T?> showPickerDialog<T>({
  required BuildContext context,
  required ItemBuilder<T> itemBuilder,
  required List<T> items,
  T? initialValue,
  int columns = 1,
  Alignment checkPosition = Alignment.center,
}) async {
  return showDialog(
    context: context,
    builder: (context) => PickerDialog<T>(
      itemBuilder: itemBuilder,
      items: items,
      columns: columns,
      initialValue: initialValue,
      checkPosition: checkPosition,
    ),
  );
}
