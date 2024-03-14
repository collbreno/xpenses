import 'package:flutter/material.dart';
import 'package:xpenses/widgets/selectable_item.dart';

typedef ItemBuilder<T> = Widget Function(T);

class PickerDialog<T> extends StatefulWidget {
  final List<T> items;
  final ItemBuilder<T> itemBuilder;
  final int columns;
  final T? initialValue;
  final Alignment checkPosition;
  final bool Function(T item, String text)? onSearch;
  const PickerDialog({
    super.key,
    required this.itemBuilder,
    required this.items,
    this.initialValue,
    this.columns = 1,
    this.onSearch,
    this.checkPosition = Alignment.center,
  });

  @override
  State<PickerDialog<T>> createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<PickerDialog<T>> {
  late List<T> _filtered;
  T? _selected;
  late bool _isSearching;

  bool get searchable => widget.onSearch != null;

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _filtered = widget.items.toList();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: searchable ? _buildSearchableTitle() : _buildStaticTitle(),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: widget.columns == 1
            ? ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: _itemBuilder,
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.columns,
                ),
                itemCount: _filtered.length,
                itemBuilder: _itemBuilder,
              ),
      ),
      actions: _buildActions(),
    );
  }

  Widget _buildStaticTitle() {
    return const Text('Selecione');
  }

  Widget _buildSearchableTitle() {
    return Row(
      children: [
        Expanded(
          child: !_isSearching
              ? _buildStaticTitle()
              : TextField(
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Pesquisar'),
                  onChanged: (query) => setState(() {
                    _filtered = widget.items
                        .where((item) => widget.onSearch!(item, query))
                        .toList();
                  }),
                ),
        ),
        IconButton(
          onPressed: () => setState(() {
            if (_isSearching) {
              _filtered = widget.items.toList();
            }
            _isSearching = !_isSearching;
          }),
          icon: AnimatedSwitcher(
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            duration: const Duration(milliseconds: 200),
            child: _isSearching
                ? const Icon(Icons.close, key: ValueKey(1))
                : const Icon(Icons.search, key: ValueKey(2)),
          ),
        ),
      ],
    );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    final item = _filtered[index];
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
  bool Function(T item, String text)? onSearch,
}) async {
  return showDialog(
    context: context,
    builder: (context) => PickerDialog<T>(
      itemBuilder: itemBuilder,
      items: items,
      columns: columns,
      initialValue: initialValue,
      checkPosition: checkPosition,
      onSearch: onSearch,
    ),
  );
}
