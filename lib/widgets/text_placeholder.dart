import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TextPlaceholder extends StatelessWidget {
  final Size size;
  const TextPlaceholder(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
      ),
    );
  }
}
