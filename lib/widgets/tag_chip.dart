import 'package:flutter/material.dart';
import 'package:xpenses/utils/color_utils.dart';

class TagChip extends StatelessWidget {
  final String text;
  final Color color;

  const TagChip({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 200,
          minWidth: 30,
          minHeight: 18,
          maxHeight: 18,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: color,
        ),
        child: FittedBox(
          alignment: Alignment.center,
          child: text.isEmpty
              ? null
              : Text(
                  text,
                  style: TextStyle(
                    color: color.contrastedColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}
