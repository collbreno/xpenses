import 'package:flutter/material.dart';

class SelectableItem extends StatelessWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onTap;
  const SelectableItem({
    super.key,
    required this.child,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          if (selected) const Icon(Icons.check),
        ],
      ),
    );
  }
}
