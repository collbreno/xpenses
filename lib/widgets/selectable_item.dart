import 'package:flutter/material.dart';

class SelectableItem extends StatelessWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onTap;
  final Alignment alignment;
  const SelectableItem({
    super.key,
    required this.child,
    this.selected = false,
    required this.onTap,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: alignment,
        children: [
          child,
          if (selected) const Icon(Icons.check),
        ],
      ),
    );
  }
}
