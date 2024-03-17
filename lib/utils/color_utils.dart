import 'package:flutter/material.dart';

class ColorUtils {
  static List<Color> getColorList() {
    final list = <Color>[];
    final materialColors = [
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
    ];

    for (final color in materialColors) {
      list.add(color.shade100);
      list.add(color.shade300);
      list.add(color);
      list.add(color.shade700);
      list.add(color.shade900);
    }

    list.add(Colors.white);
    list.add(Colors.grey.shade300);
    list.add(Colors.grey);
    list.add(Colors.grey.shade700);
    list.add(Colors.black);

    return list;
  }
}

extension ColorUtilsExtension on Color {
  Color get contrastedColor =>
      computeLuminance() > 0.3 ? Colors.black : Colors.white;
}
