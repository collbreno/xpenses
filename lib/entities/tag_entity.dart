import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Tag {
  int id = 0;

  String name;

  @Transient()
  Color color;
  int get colorCode => color.value;
  set colorCode(int code) => color = Color(code);

  @Transient()
  IconData? get icon => iconMap[iconName];

  String? iconName;

  Tag({
    required this.name,
    this.color = Colors.grey,
    required this.iconName,
  });
}
