import 'package:flutter/material.dart';
import 'package:xpenses/widgets/selectable_item.dart';

class PickerDialogProps<T> {
  final List<T> items;
  final ItemBuilder<T> itemBuilder;
  final int columns;
  final bool Function(T item, String text)? onSearch;
  final Alignment checkPosition;

  PickerDialogProps({
    required this.items,
    required this.itemBuilder,
    this.columns = 1,
    this.onSearch,
    this.checkPosition = Alignment.center,
  });
}

typedef ItemBuilder<T> = Widget Function(T);

class PickerDialog<T> extends StatefulWidget {
  final T? initialValue;
  final PickerDialogProps<T> props;
  const PickerDialog({
    super.key,
    required this.props,
    this.initialValue,
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
    return _InnerPickerDialog<T>(
      isSelected: (item) => _selected == item,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () => Navigator.of(context).pop(_selected),
      onItemPressed: (item) {
        setState(() {
          _selected = _selected == item ? null : item;
        });
      },
      props: widget.props,
    );
  }
}

class MultiPickerDialog<T> extends StatefulWidget {
  final Iterable<T> initialValue;
  final PickerDialogProps<T> props;
  const MultiPickerDialog({
    super.key,
    required this.props,
    required this.initialValue,
  });

  @override
  State<MultiPickerDialog<T>> createState() => _MultiPickerDialogState<T>();
}

class _MultiPickerDialogState<T> extends State<MultiPickerDialog<T>> {
  late Set<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return _InnerPickerDialog<T>(
      isSelected: (item) => _selected.contains(item),
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () => Navigator.of(context).pop(_selected),
      onItemPressed: (item) {
        setState(() {
          if (_selected.contains(item)) {
            _selected.remove(item);
          } else {
            _selected.add(item);
          }
        });
      },
      props: widget.props,
    );
  }
}

class _InnerPickerDialog<T> extends StatefulWidget {
  final ValueSetter<T> onItemPressed;
  final bool Function(T) isSelected;
  final PickerDialogProps<T> props;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  const _InnerPickerDialog({
    super.key,
    required this.onItemPressed,
    required this.props,
    required this.onCancel,
    required this.onConfirm,
    required this.isSelected,
  });

  @override
  State<_InnerPickerDialog<T>> createState() => _InnerPickerDialogState<T>();
}

class _InnerPickerDialogState<T> extends State<_InnerPickerDialog<T>> {
  late List<T> _filtered;
  late bool _isSearching;

  bool get searchable => widget.props.onSearch != null;

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _filtered = widget.props.items.toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: searchable ? _buildSearchableTitle() : _buildStaticTitle(),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: widget.props.columns == 1
            ? ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: _itemBuilder,
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.props.columns,
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
                    _filtered = widget.props.items
                        .where((item) => widget.props.onSearch!(item, query))
                        .toList();
                  }),
                ),
        ),
        IconButton(
          onPressed: () => setState(() {
            if (_isSearching) {
              _filtered = widget.props.items.toList();
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
      alignment: widget.props.checkPosition,
      selected: widget.isSelected(item),
      onTap: () {
        widget.onItemPressed(item);
      },
      child: widget.props.itemBuilder(
        item,
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      TextButton(
        onPressed: widget.onCancel,
        child: const Text('Cancelar'),
      ),
      TextButton(
        onPressed: widget.onConfirm,
        child: const Text('Ok'),
      ),
    ];
  }
}

Future<T?> showPickerDialog<T>({
  required BuildContext context,
  required PickerDialogProps<T> props,
  T? initialValue,
}) async {
  return showDialog(
    context: context,
    builder: (context) => PickerDialog<T>(
      props: props,
      initialValue: initialValue,
    ),
  );
}

Future<Iterable<T>?> showMultiPickerDialog<T>({
  required BuildContext context,
  required PickerDialogProps<T> props,
  Iterable<T>? initialValue,
}) async {
  return showDialog(
    context: context,
    builder: (context) => MultiPickerDialog<T>(
      props: props,
      initialValue: initialValue ?? <T>{},
    ),
  );
}
