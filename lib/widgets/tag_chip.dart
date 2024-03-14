import 'package:flutter/material.dart';
import 'package:xpenses/utils/color_utils.dart';

class TagChip extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final Alignment alignment;

  const TagChip({
    super.key,
    required this.text,
    required this.color,
    this.icon,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 200,
          minWidth: 30,
          minHeight: 22,
          maxHeight: 22,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: color,
        ),
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Icon(
                    icon,
                    color: color.contrastedColor,
                  ),
                ),
              Text(
                text.isEmpty ? ' ' : text,
                style: TextStyle(
                  color: color.contrastedColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
